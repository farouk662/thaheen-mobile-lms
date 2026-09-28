import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/adaptive/app_back_button.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';
import '../manager/player_cubit.dart';
import '../manager/player_state.dart';

class PlayerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlayerAppBar({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocSelector<PlayerCubit, PlayerState, Lesson?>(
        selector: (state) => state is PlayerLoaded ? state.data.currentLesson : null,
        builder: (context, lesson) => Text(
          lesson?.displayTitle(context) ?? '',
          style: AppTextStyles.title.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      centerTitle: false,
      leading: AppBackButton(onPressed: onBack),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
