import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.sectionLabel.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
