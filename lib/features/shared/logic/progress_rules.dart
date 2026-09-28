import '../data/models/course.dart';
import '../data/models/lesson.dart';

// Pure Dart progress calculation rules — ZERO Flutter imports allowed.

/// Determines if a lesson is completed based on the 90% watched threshold.
bool isLessonCompleted(int watchedSec, int durationSec) {
  if (durationSec <= 0) return false;
  return watchedSec / durationSec >= 0.9;
}

/// Determines if a lesson is unlocked across the entire course.
/// The first lesson of the course (index 0) is always unlocked.
/// Subsequent lessons only unlock when their immediate previous lesson is completed.
bool isLessonUnlocked(
  int lessonIndex,
  List<String> completedLessonIds,
  List<Lesson> allLessons,
) {
  if (lessonIndex == 0) return true;
  if (lessonIndex < 0 || lessonIndex >= allLessons.length) return false;
  final previousLesson = allLessons[lessonIndex - 1];
  return completedLessonIds.contains(previousLesson.id);
}

/// Computes the completion percentage (0.0 → 1.0) for a list of lessons.
double courseProgressPercent(
  List<Lesson> allLessons,
  List<String> completedLessonIds,
) {
  if (allLessons.isEmpty) return 0.0;
  final completedCount =
      allLessons.where((l) => completedLessonIds.contains(l.id)).length;
  return completedCount / allLessons.length;
}

/// Total lesson count across all sections of a course.
int courseLessonCount(Course course) => course.totalLessons;

/// Overall completion percentage (0.0 → 1.0) for a single course.
double courseCompletionPercent(Course course, List<String> completedIds) =>
    courseProgressPercent(course.allLessons, completedIds);
