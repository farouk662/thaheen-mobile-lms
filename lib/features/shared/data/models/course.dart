import 'course_section.dart';
import 'lesson.dart';

class Course {
  const Course({
    required this.id,
    required this.title,
    this.titleEn,
    required this.instructor,
    this.instructorEn,
    required this.thumbnail,
    required this.sections,
  });

  final String id;
  final String title;
  final String? titleEn;
  final String instructor;
  final String? instructorEn;
  final String thumbnail;
  final List<CourseSection> sections;

  /// Returns a flattened list of all lessons across all sections in order.
  List<Lesson> get allLessons =>
      sections.expand((s) => s.lessons).toList();

  /// Total count of lessons in this course.
  int get totalLessons =>
      sections.fold(0, (sum, s) => sum + s.lessons.length);

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      instructor: json['instructor'] as String,
      instructorEn: json['instructorEn'] as String?,
      thumbnail: json['thumbnail'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((s) => CourseSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
