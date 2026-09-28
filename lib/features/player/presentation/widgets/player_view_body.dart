import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_error_view.dart';
import 'package:thaheen_lms/core/widgets/feedback/app_loading_view.dart';
import '../manager/player_cubit.dart';
import '../manager/player_state.dart';
import 'player_loaded_body.dart';

class PlayerViewBody extends StatelessWidget {
  const PlayerViewBody({super.key, required this.courseId, required this.lessonId});

  final String courseId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerState>(
      builder: (context, state) => switch (state) {
        PlayerInitial() || PlayerLoading() => const AppLoadingView(),
        PlayerError(:final message) => AppErrorView(
          message: message,
          onRetry: () => context.read<PlayerCubit>().loadLessonPlayer(courseId: courseId, lessonId: lessonId),
        ),
        PlayerLoaded(:final data) => PlayerLoadedBody(
          data: data,
          onRetry: () => context.read<PlayerCubit>().loadLessonPlayer(courseId: courseId, lessonId: lessonId),
        ),
      },
    );
  }
}
