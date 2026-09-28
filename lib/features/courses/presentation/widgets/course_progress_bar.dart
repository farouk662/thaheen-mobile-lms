import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';

class CourseProgressBar extends StatelessWidget {
  const CourseProgressBar({super.key, required this.percent});
  final double percent; // 0.0–1.0

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: percent.clamp(0.0, 1.0),
        minHeight: 4,
        color: context.colorScheme.primary,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
