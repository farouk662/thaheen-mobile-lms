import 'course.dart';
import 'course_section.dart';
import 'lesson.dart';

enum LessonStatus { notStarted, inProgress, completed }

class LessonRow {
  const LessonRow({
    required this.lesson,
    required this.status,
    required this.isLocked,
    required this.positionSec,
  });

  final Lesson lesson;
  final LessonStatus status;
  final bool isLocked;
  final int positionSec;
}

class SectionWithLessons {
  const SectionWithLessons({
    required this.section,
    required this.lessons,
  });

  final CourseSection section;
  final List<LessonRow> lessons;
}

class CourseDetailsData {
  const CourseDetailsData({
    required this.course,
    required this.sections,
    required this.progressPercent,
  });

  final Course course;
  final List<SectionWithLessons> sections;
  final double progressPercent;
}
