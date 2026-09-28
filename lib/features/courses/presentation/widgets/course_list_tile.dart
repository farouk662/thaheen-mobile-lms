import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/adaptive/app_forward_icon.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';
import 'course_progress_bar.dart';

class CourseListTile extends StatelessWidget {
  const CourseListTile({
    super.key,
    required this.course,
    required this.lessonCount,
    required this.progressPercent,
    required this.onTap,
  });

  final Course course;
  final int lessonCount;
  final double progressPercent;
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
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Thumbnail — rightmost in RTL
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    course.thumbnail,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 52,
                      height: 52,
                      color: colorScheme.primaryContainer,
                      child: Icon(Icons.school_rounded, color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.displayTitle(context),
                        style: AppTextStyles.cardTitle.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${course.displayInstructor(context)} · $lessonCount ${AppStrings.lessons}',
                        style: AppTextStyles.caption.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppForwardIcon(color: colorScheme.onSurfaceVariant, size: 20),
              ],
            ),
            if (progressPercent > 0) ...[
              const SizedBox(height: 10),
              CourseProgressBar(percent: progressPercent),
            ],
          ],
        ),
      ),
    );
  }
}
