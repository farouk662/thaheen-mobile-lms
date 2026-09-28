import 'lesson.dart';

class CourseSection {
  const CourseSection({
    required this.id,
    required this.title,
    this.titleEn,
    required this.lessons,
  });

  final String id;
  final String title;
  final String? titleEn;
  final List<Lesson> lessons;

  factory CourseSection.fromJson(Map<String, dynamic> json) {
    return CourseSection(
      id: json['id'] as String,
      title: json['title'] as String,
      titleEn: json['titleEn'] as String?,
      lessons: (json['lessons'] as List<dynamic>)
          .map((l) => Lesson.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }
}
