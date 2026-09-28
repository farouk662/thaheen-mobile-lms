import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson_note.dart';

class LessonNoteItemTile extends StatelessWidget {
  const LessonNoteItemTile({
    super.key,
    required this.note,
    required this.onDelete,
  });

  final LessonNote note;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.format_quote_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note.text,
              style: AppTextStyles.body.copyWith(
                color: colorScheme.onSurface,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 18,
              color: colorScheme.error.withValues(alpha: 0.8),
            ),
            tooltip: AppStrings.deleteNote,
            visualDensity: VisualDensity.compact,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
