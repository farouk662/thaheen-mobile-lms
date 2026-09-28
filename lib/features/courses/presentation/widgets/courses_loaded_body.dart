import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thaheen_lms/core/routing/app_router.dart';
import '../manager/courses_cubit.dart';
import '../manager/courses_state.dart';
import 'continue_watching_sliver.dart';
import 'courses_list_sliver.dart';
import 'courses_search_bar_sliver.dart';
import 'courses_search_empty_sliver.dart';

class CoursesLoadedBody extends StatelessWidget {
  const CoursesLoadedBody({
    super.key,
    required this.state,
  });

  final CoursesLoaded state;

  @override
  Widget build(BuildContext context) {
    final isSearching = state.searchQuery.trim().isNotEmpty;

    return CustomScrollView(
      slivers: [
        const CoursesSearchBarSliver(),
        if (!isSearching &&
            state.continueWatchingLesson != null &&
            state.continueWatchingCourse != null)
          ContinueWatchingSliver(
            lesson: state.continueWatchingLesson!,
            parentCourse: state.continueWatchingCourse!,
            progress: state.continueWatchingProgress ?? 0,
            onTap: () async {
              await context.push(
                AppRouter.player,
                extra: {
                  'courseId': state.continueWatchingCourse!.id,
                  'lessonId': state.continueWatchingLesson!.id,
                },
              );
              if (context.mounted) {
                context.read<CoursesCubit>().loadCourses();
              }
            },
          ),
        if (state.courses.isEmpty && isSearching)
          const CoursesSearchEmptySliver()
        else
          CoursesListSliver(
            courses: state.courses,
            completedLessonIds: state.completedLessonIds,
          ),
      ],
    );
  }
}
