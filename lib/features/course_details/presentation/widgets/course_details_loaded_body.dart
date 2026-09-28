import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/routing/app_router.dart';
import 'package:thaheen_lms/features/shared/data/models/course_details_data.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';
import '../manager/course_details_cubit.dart';
import 'course_details_header.dart';
import 'lesson_tile.dart';
import 'section_header_tile.dart';

class CourseDetailsLoadedBody extends StatelessWidget {
  const CourseDetailsLoadedBody({
    super.key,
    required this.data,
  });

  final CourseDetailsData data;

  void _onLessonTap(BuildContext context, LessonRow lessonRow) async {
    await context.push(
      AppRouter.player,
      extra: {
        'courseId': data.course.id,
        'lessonId': lessonRow.lesson.id,
      },
    );
    // Reload details after returning from player to update progress & unlock states
    if (context.mounted) {
      context.read<CourseDetailsCubit>().loadCourseDetails(data.course.id);
    }
  }

  void _onLockedTap(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.lockedLessonMessage),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                CourseDetailsHeader(
                  course: data.course,
                  progressPercent: data.progressPercent,
                ),
                for (final sectionData in data.sections) ...[
                  SectionHeaderTile(
                    title: sectionData.section.displayTitle(context),
                    lessonCount: sectionData.lessons.length,
                  ),
                  for (final lessonRow in sectionData.lessons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LessonTile(
                        lessonRow: lessonRow,
                        onTap: () => _onLessonTap(context, lessonRow),
                        onLockedTap: () => _onLockedTap(context),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
