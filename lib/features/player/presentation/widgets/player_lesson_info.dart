import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'package:thaheen_lms/features/shared/presentation/extensions/model_display_extension.dart';

class PlayerLessonInfo extends StatelessWidget {
  const PlayerLessonInfo({super.key, required this.lesson, required this.course, required this.isCompleted});

  final Lesson lesson;
  final Course course;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.displayTitle(context),
                      style: AppTextStyles.title.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('${course.displayTitle(context)} · ${course.displayInstructor(context)}', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.lessonCompleted,
                        style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
