import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson_player_data.dart';
import '../manager/player_cubit.dart';
import 'lesson_notes_card.dart';
import 'next_lesson_button.dart';
import 'player_lesson_info.dart';
import 'player_video_box.dart';
import 'speed_menu.dart';

class PlayerLoadedBody extends StatelessWidget {
  const PlayerLoadedBody({
    super.key,
    required this.data,
    required this.onRetry,
  });

  final LessonPlayerData data;
  final VoidCallback onRetry;

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
    final cubit = context.read<PlayerCubit>();

    return Column(
      children: [
        PlayerVideoBox(
          key: ValueKey(data.currentLesson.id),
          lessonId: data.currentLesson.id,
          videoUrl: data.currentLesson.video,
          initialPositionSec: data.savedPositionSec,
          playbackSpeed: data.preferredSpeed,
          onRetry: onRetry,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlayerLessonInfo(
                  lesson: data.currentLesson,
                  course: data.course,
                  isCompleted: data.isCompleted,
                ),
                const SizedBox(height: 16),
                SpeedMenu(
                  currentSpeed: data.preferredSpeed,
                  onSpeedSelected: (speed) => cubit.setPlaybackSpeed(speed),
                ),
                const SizedBox(height: 16),
                NextLessonButton(
                  nextLesson: data.nextLesson,
                  isUnlocked: data.isNextLessonUnlocked,
                  onNextTap: data.nextLesson != null
                      ? () => cubit.loadLessonPlayer(
                            courseId: data.course.id,
                            lessonId: data.nextLesson!.id,
                          )
                      : null,
                  onLockedTap: () => _onLockedTap(context),
                ),
                const SizedBox(height: 16),
                LessonNotesCard(
                  key: ValueKey(data.currentLesson.id),
                  lessonId: data.currentLesson.id,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
