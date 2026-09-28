import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/buttons/app_button.dart';
import 'package:thaheen_lms/core/widgets/fields/app_text_field.dart';

class AddLessonNoteSheet extends StatefulWidget {
  const AddLessonNoteSheet({
    super.key,
    required this.onAddNote,
  });

  final ValueChanged<String> onAddNote;

  static Future<void> show(BuildContext context, {required ValueChanged<String> onAddNote}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddLessonNoteSheet(onAddNote: onAddNote),
    );
  }

  @override
  State<AddLessonNoteSheet> createState() => _AddLessonNoteSheetState();
}

class _AddLessonNoteSheetState extends State<AddLessonNoteSheet> {
  late final TextEditingController _controller;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    final canSubmit = text.trim().isNotEmpty;
    if (canSubmit != _canSubmit) {
      setState(() => _canSubmit = canSubmit);
    }
  }

  void _onSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onAddNote(text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.add_comment_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.addNote,
                style: AppTextStyles.cardTitle.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _controller,
            autofocus: true,
            onChanged: _onChanged,
            hintText: AppStrings.newNoteHint,
            minLines: 3,
            maxLines: 6,
            contentPadding: const EdgeInsets.all(14),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: AppStrings.addNote,
            icon: const Icon(Icons.check_rounded),
            onPressed: _canSubmit ? _onSubmit : null,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
