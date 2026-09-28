import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/features/shared/data/models/course_details_data.dart';

class LessonStatusBadge extends StatelessWidget {
  const LessonStatusBadge({
    super.key,
    required this.status,
  });

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label, IconData icon) = switch (status) {
      LessonStatus.completed => (
          AppColors.success.withValues(alpha: 0.12),
          AppColors.success,
          AppStrings.lessonCompleted,
          Icons.check_circle_rounded,
        ),
      LessonStatus.inProgress => (
          AppColors.primaryLight.withValues(alpha: 0.12),
          AppColors.primaryLight,
          AppStrings.lessonInProgress,
          Icons.play_circle_fill_rounded,
        ),
      LessonStatus.notStarted => (
          context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          context.colorScheme.onSurfaceVariant,
          AppStrings.lessonNotStarted,
          Icons.radio_button_unchecked_rounded,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
