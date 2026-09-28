import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_empty_view.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_error_view.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_loading_view.dart';
import '../manager/course_details_cubit.dart';
import '../manager/course_details_state.dart';
import 'course_details_loaded_body.dart';

class CourseDetailsViewBody extends StatelessWidget {
  const CourseDetailsViewBody({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
      builder: (context, state) => switch (state) {
        CourseDetailsInitial() => const SizedBox.shrink(),
        CourseDetailsLoading() => const AppLoadingView(),
        CourseDetailsEmpty() => AppEmptyView(message: AppStrings.noLessons),
        CourseDetailsError(:final message) => AppErrorView(
            message: message,
            onRetry: () =>
                context.read<CourseDetailsCubit>().loadCourseDetails(courseId),
          ),
        CourseDetailsLoaded(:final data) =>
          CourseDetailsLoadedBody(data: data),
      },
    );
  }
}
