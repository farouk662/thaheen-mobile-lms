import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';
import 'course_progress_bar.dart';

class ContinueWatchingCard extends StatelessWidget {
  const ContinueWatchingCard({
    super.key,
    required this.lesson,
    required this.parentCourse,
    required this.progress, // 0.0–1.0
    required this.onTap,
  });

  final Lesson lesson;
  final Course parentCourse;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.continueWatching,
              style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Thumbnail — rightmost in RTL
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    parentCourse.thumbnail,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52,
                      height: 52,
                      color: colorScheme.primaryContainer,
                      child: Icon(Icons.play_lesson_rounded, color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.displayTitle(context),
                        style: AppTextStyles.cardTitle.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        parentCourse.displayTitle(context),
                        style: AppTextStyles.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.play_circle_outline, color: colorScheme.primary, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            CourseProgressBar(percent: progress),
          ],
        ),
      ),
    );
  }
}
