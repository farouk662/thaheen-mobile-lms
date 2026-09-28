import 'package:flutter/material.dart';
import '../../extensions/build_context_extension.dart';
import '../../theme/app_text_styles.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: context.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTextStyles.body.copyWith(color: context.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
