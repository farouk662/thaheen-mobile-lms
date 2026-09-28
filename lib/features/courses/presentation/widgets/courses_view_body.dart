import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_empty_view.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_error_view.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_loading_view.dart';
import '../manager/courses_cubit.dart';
import '../manager/courses_state.dart';
import 'courses_loaded_body.dart';

class CoursesViewBody extends StatelessWidget {
  const CoursesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) => switch (state) {
        CoursesInitial() => const SizedBox.shrink(),
        CoursesLoading() => const AppLoadingView(),
        CoursesEmpty() => AppEmptyView(message: AppStrings.noCourses),
        CoursesError(:final message) => AppErrorView(
            message: message,
            onRetry: () => context.read<CoursesCubit>().loadCourses(),
          ),
        CoursesLoaded() => CoursesLoadedBody(state: state),
      },
    );
  }
}
