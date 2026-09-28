import 'course.dart';
import 'lesson.dart';

/// Result bundle returned by [CourseRepository.getCoursesData] and
/// consumed by [CoursesCubit].
class CoursesData {
  const CoursesData({
    required this.courses,
    required this.completedLessonIds,
    this.continueWatchingLesson,
    this.continueWatchingCourse,
    this.continueWatchingProgress,
  });

  final List<Course> courses;
  final List<String> completedLessonIds;
  final Lesson? continueWatchingLesson;
  final Course? continueWatchingCourse;

  /// positionSec / durationSec — used by the continue-watching card's progress bar.
  final double? continueWatchingProgress;
}
