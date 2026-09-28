import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';

class SectionHeaderTile extends StatelessWidget {
  const SectionHeaderTile({
    super.key,
    required this.title,
    required this.lessonCount,
  });

  final String title;
  final int lessonCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$lessonCount ${AppStrings.lessons}',
              style: AppTextStyles.caption.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
