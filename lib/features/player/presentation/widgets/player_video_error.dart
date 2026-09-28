import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/buttons/app_button.dart';

class PlayerVideoError extends StatelessWidget {
  const PlayerVideoError({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            AppButton(
              text: AppStrings.retry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              variant: AppButtonVariant.outline,
              textColor: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
