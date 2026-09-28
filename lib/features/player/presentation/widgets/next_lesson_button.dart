import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/adaptive/app_forward_icon.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';

class NextLessonButton extends StatelessWidget {
  const NextLessonButton({
    super.key,
    required this.nextLesson,
    required this.isUnlocked,
    this.onNextTap,
    this.onLockedTap,
  });

  final Lesson? nextLesson;
  final bool isUnlocked;
  final VoidCallback? onNextTap;
  final VoidCallback? onLockedTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    if (nextLesson == null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 18, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              AppStrings.noNextLesson,
              style: AppTextStyles.body.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final lesson = nextLesson!;

    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: isUnlocked
            ? null
            : Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          else
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isUnlocked ? onNextTap : onLockedTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  isUnlocked ? Icons.play_circle_filled_rounded : Icons.lock_outline_rounded,
                  color: isUnlocked ? Colors.white : colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.nextLesson,
                        style: AppTextStyles.caption.copyWith(
                          color: isUnlocked ? Colors.white70 : colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        lesson.displayTitle(context),
                        style: AppTextStyles.body.copyWith(
                          color: isUnlocked ? Colors.white : colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppForwardIcon(
                  color: isUnlocked ? Colors.white : colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
