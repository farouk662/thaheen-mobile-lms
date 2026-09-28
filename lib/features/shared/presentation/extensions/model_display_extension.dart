import 'package:flutter/material.dart';
import '../../../../core/extensions/build_context_extension.dart';
import '../../data/models/course.dart';
import '../../data/models/course_section.dart';
import '../../data/models/lesson.dart';

extension LocalizedCourseX on Course {
  String displayTitle(BuildContext context) =>
      (context.isEnglish && titleEn != null) ? titleEn! : title;

  String displayInstructor(BuildContext context) =>
      (context.isEnglish && instructorEn != null) ? instructorEn! : instructor;
}

extension LocalizedCourseSectionX on CourseSection {
  String displayTitle(BuildContext context) =>
      (context.isEnglish && titleEn != null) ? titleEn! : title;
}

extension LocalizedLessonX on Lesson {
  String displayTitle(BuildContext context) =>
      (context.isEnglish && titleEn != null) ? titleEn! : title;
}
