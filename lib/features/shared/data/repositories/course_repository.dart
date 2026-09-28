import '../../../../core/constants/app_keys.dart';
import '../../../../core/localization/app_strings.dart';
import '../../logic/app_exception.dart';
import '../../logic/progress_rules.dart';

import '../datasources/courses_local_data_source.dart';
import '../datasources/notes_local_data_source.dart';
import '../datasources/progress_local_data_source.dart';
import '../models/course.dart';
import '../models/course_details_data.dart';
import '../models/courses_data.dart';
import '../models/lesson.dart';
import '../models/lesson_note.dart';
import '../models/lesson_player_data.dart';

/// Index built once per [getCoursesData] call to avoid repeated nested loops.
typedef _LessonIndex = ({Map<String, int> durations, Map<String, Lesson> lessonById, Map<String, Course> courseByLessonId});

class CourseRepository {
  const CourseRepository(
    this._coursesLocalDataSource,
    this._progressLocalDataSource,
    this._notesLocalDataSource,
  );

  final CoursesLocalDataSource _coursesLocalDataSource;
  final ProgressLocalDataSource _progressLocalDataSource;
  final NotesLocalDataSource _notesLocalDataSource;

  // ── Public API ────────────────────────────────────────────────────────────

  Future<CoursesData> getCoursesData() async {
    final courses = await _loadCourses();
    final index = _buildLessonIndex(courses);
    final allLessons = courses.expand((c) => c.allLessons).toList();
    final completedIds = _resolveCompletedIds(allLessons);
    final continueWatching = _resolveContinueWatching(index, completedIds);

    return CoursesData(
      courses: courses,
      completedLessonIds: completedIds,
      continueWatchingLesson: continueWatching?.$1,
      continueWatchingCourse: continueWatching?.$2,
      continueWatchingProgress: continueWatching?.$3,
    );
  }

  Future<CourseDetailsData> getCourseDetails(String courseId) async {
    final course = await _findCourse(courseId);
    final completedIds = _resolveCompletedIds(course.allLessons);
    final sections = _buildSectionsWithLessons(course, completedIds);
    final progressPercent = courseCompletionPercent(course, completedIds);

    return CourseDetailsData(course: course, sections: sections, progressPercent: progressPercent);
  }

  Future<LessonPlayerData> getLessonPlayerData({required String courseId, required String lessonId}) async {
    final course = await _findCourse(courseId);
    final allLessons = course.allLessons;
    final currentIndex = allLessons.indexWhere((l) => l.id == lessonId);
    if (currentIndex == -1) {
      throw AppException(AppStrings.lessonNotFound);
    }

    final currentLesson = allLessons[currentIndex];
    final nextLesson = (currentIndex + 1 < allLessons.length) ? allLessons[currentIndex + 1] : null;

    final completedIds = _resolveCompletedIds(allLessons);
    final isCompleted = completedIds.contains(lessonId);
    final progressMap = _progressLocalDataSource.getProgress(lessonId);
    final savedPositionSec = (progressMap?[AppKeys.positionSec] as int?) ?? 0;

    final isNextUnlocked = nextLesson != null ? isLessonUnlocked(currentIndex + 1, completedIds, allLessons) : false;

    final preferredSpeed = _progressLocalDataSource.getPreferredPlaybackSpeed();

    return LessonPlayerData(
      course: course,
      currentLesson: currentLesson,
      nextLesson: nextLesson,
      isNextLessonUnlocked: isNextUnlocked,
      savedPositionSec: savedPositionSec,
      isCompleted: isCompleted,
      preferredSpeed: preferredSpeed,
    );
  }

  Future<void> saveLessonProgress({required String lessonId, required int positionSec, required bool completed}) async {
    await _progressLocalDataSource.saveProgress(lessonId: lessonId, positionSec: positionSec, completed: completed);
  }

  Future<void> savePreferredPlaybackSpeed(double speed) async {
    await _progressLocalDataSource.savePreferredPlaybackSpeed(speed);
  }

  String getLessonNote(String lessonId) {
    return _notesLocalDataSource.getLessonNote(lessonId);
  }

  Future<void> saveLessonNote({required String lessonId, required String note}) async {
    await _notesLocalDataSource.saveLessonNote(lessonId: lessonId, note: note);
  }

  List<LessonNote> getLessonNotes(String lessonId) {
    return _notesLocalDataSource.getLessonNotes(lessonId);
  }

  Future<void> addLessonNote({required String lessonId, required String text}) async {
    await _notesLocalDataSource.addLessonNote(lessonId: lessonId, text: text);
  }

  Future<void> deleteLessonNote({required String lessonId, required String noteId}) async {
    await _notesLocalDataSource.deleteLessonNote(lessonId: lessonId, noteId: noteId);
  }

  // ── Private Helpers ───────────────────────────────────────────────────────

  Future<List<Course>> _loadCourses() async {
    try {
      return await _coursesLocalDataSource.getCourses();
    } catch (_) {
      throw AppException(AppStrings.loadCoursesError);
    }
  }

  Future<Course> _findCourse(String courseId) async {
    final courses = await _loadCourses();
    final course = courses.where((c) => c.id == courseId).firstOrNull;
    if (course == null) {
      throw AppException(AppStrings.courseNotFound);
    }
    return course;
  }

  List<String> _resolveCompletedIds(List<Lesson> lessons) {
    final completedSet = _progressLocalDataSource.getCompletedLessonIds().toSet();

    for (final lesson in lessons) {
      final progress = _progressLocalDataSource.getProgress(lesson.id);
      final positionSec = (progress?[AppKeys.positionSec] as int?) ?? 0;
      final completed = (progress?[AppKeys.completed] as bool?) ?? false;

      if (completed) {
        // Trust the persisted completed flag — it was written only after genuine
        // 90 % playback or an explicit completion event.
        completedSet.add(lesson.id);
      } else if (isLessonCompleted(positionSec, lesson.durationSec)) {
        // Position proves the user watched ≥ 90 % but the flag was never written
        // (e.g. app was force-killed). Heal it now.
        completedSet.add(lesson.id);
        _progressLocalDataSource.saveProgress(
          lessonId: lesson.id,
          positionSec: positionSec,
          completed: true,
        );
      }
      // In all other cases leave the lesson as not-completed — no removal needed
      // because it was never in completedSet to begin with.
    }

    return completedSet.toList();
  }

  List<SectionWithLessons> _buildSectionsWithLessons(Course course, List<String> completedIds) {
    final allLessons = course.allLessons;

    return course.sections.map((section) {
      final lessonRows = section.lessons.map((lesson) {
        final globalIndex = allLessons.indexWhere((l) => l.id == lesson.id);
        assert(globalIndex != -1, 'Lesson ${lesson.id} must exist in course.allLessons');
        final isLocked = !isLessonUnlocked(globalIndex, completedIds, allLessons);
        final progressMap = _progressLocalDataSource.getProgress(lesson.id);
        final positionSec = (progressMap?[AppKeys.positionSec] as int?) ?? 0;
        final isCompleted = completedIds.contains(lesson.id);

        final LessonStatus status;
        if (isCompleted) {
          status = LessonStatus.completed;
        } else if (positionSec > 0) {
          status = LessonStatus.inProgress;
        } else {
          status = LessonStatus.notStarted;
        }

        return LessonRow(lesson: lesson, status: status, isLocked: isLocked, positionSec: positionSec);
      }).toList();

      return SectionWithLessons(section: section, lessons: lessonRows);
    }).toList();
  }

  _LessonIndex _buildLessonIndex(List<Course> courses) {
    final durations = <String, int>{};
    final lessonById = <String, Lesson>{};
    final courseByLessonId = <String, Course>{};

    for (final course in courses) {
      for (final section in course.sections) {
        for (final lesson in section.lessons) {
          durations[lesson.id] = lesson.durationSec;
          lessonById[lesson.id] = lesson;
          courseByLessonId[lesson.id] = course;
        }
      }
    }

    return (durations: durations, lessonById: lessonById, courseByLessonId: courseByLessonId);
  }

  /// Returns `(lesson, course, progress)` for the most recent in-progress lesson,
  /// or `null` if there is nothing to continue.
  (Lesson, Course, double)? _resolveContinueWatching(_LessonIndex index, List<String> completedIds) {
    final inProgress = _progressLocalDataSource.getMostRecentInProgress(index.lessonById.keys.toList(), index.durations);
    if (inProgress == null || completedIds.contains(inProgress.lessonId)) return null;

    final lesson = index.lessonById[inProgress.lessonId];
    final course = index.courseByLessonId[inProgress.lessonId];
    if (lesson == null || course == null) return null;

    final duration = index.durations[inProgress.lessonId] ?? 1;
    final progress = inProgress.positionSec / duration;

    return (lesson, course, progress);
  }
}
