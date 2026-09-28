import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_lms/core/routing/app_router.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/logic/progress_rules.dart';
import '../manager/courses_cubit.dart';
import 'course_list_tile.dart';

class CoursesListSliver extends StatelessWidget {
  const CoursesListSliver({
    super.key,
    required this.courses,
    required this.completedLessonIds,
    this.onCourseTap,
  });

  final List<Course> courses;
  final List<String> completedLessonIds;
  final ValueChanged<Course>? onCourseTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverList.separated(
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseListTile(
            course: course,
            lessonCount: courseLessonCount(course),
            progressPercent: courseCompletionPercent(
              course,
              completedLessonIds,
            ),
            onTap: () async {
              onCourseTap?.call(course);
              await context.push(AppRouter.courseDetails, extra: course.id);
              if (context.mounted) {
                context.read<CoursesCubit>().loadCourses();
              }
            },
          );
        },
      ),
    );
  }
}
