import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/features/shared/data/models/course_details_data.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';
import 'lesson_status_badge.dart';

class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lessonRow,
    required this.onTap,
    required this.onLockedTap,
  });

  final LessonRow lessonRow;
  final VoidCallback onTap;
  final VoidCallback onLockedTap;

  String _formatDuration(int totalSec) {
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final lesson = lessonRow.lesson;
    final isLocked = lessonRow.isLocked;

    return Material(
      color: isLocked ? colorScheme.surface.withValues(alpha: 0.5) : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLocked ? onLockedTap : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLocked
                  ? colorScheme.outlineVariant.withValues(alpha: 0.3)
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              // Icon: Lock or Status indicator
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isLocked
                      ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                      : (lessonRow.status == LessonStatus.completed
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.primary.withValues(alpha: 0.08)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked
                      ? Icons.lock_outline_rounded
                      : (lessonRow.status == LessonStatus.completed
                          ? Icons.check_rounded
                          : Icons.play_arrow_rounded),
                  color: isLocked
                      ? colorScheme.onSurfaceVariant
                      : (lessonRow.status == LessonStatus.completed
                          ? AppColors.success
                          : AppColors.primary),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Lesson details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.displayTitle(context),
                      style: AppTextStyles.body.copyWith(
                        color: isLocked ? colorScheme.onSurface.withValues(alpha: 0.5) : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(lesson.durationSec),
                          style: AppTextStyles.caption.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status Badge or Lock indicator
              if (!isLocked)
                LessonStatusBadge(status: lessonRow.status)
              else
                Icon(
                  Icons.lock_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
