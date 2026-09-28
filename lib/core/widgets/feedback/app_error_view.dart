import 'package:flutter/material.dart';
import '../../extensions/build_context_extension.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/app_button.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: context.colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              AppButton(
                text: AppStrings.retry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
