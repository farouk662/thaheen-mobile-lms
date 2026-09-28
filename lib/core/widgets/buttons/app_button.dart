import 'package:flutter/material.dart';
import '../../extensions/build_context_extension.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.height = 48.0,
    this.width,
    this.borderRadius = 14.0,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final double height;
  final double? width;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isEnabled = onPressed != null && !isLoading;

    Color bg;
    Color fg;
    Border? border;
    List<BoxShadow>? shadows;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = backgroundColor ?? AppColors.primary;
        fg = textColor ?? Colors.white;
        if (isEnabled) {
          shadows = [
            BoxShadow(
              color: bg.withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ];
        }
        break;

      case AppButtonVariant.secondary:
        bg = backgroundColor ?? colorScheme.primary.withValues(alpha: 0.08);
        fg = textColor ?? AppColors.primary;
        break;

      case AppButtonVariant.outline:
        bg = backgroundColor ?? Colors.transparent;
        fg = textColor ?? AppColors.primary;
        border = Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        );
        break;
    }

    if (!isEnabled) {
      bg = colorScheme.onSurface.withValues(alpha: 0.08);
      fg = colorScheme.onSurface.withValues(alpha: 0.38);
      shadows = null;
    }

    final radius = BorderRadius.circular(borderRadius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: border,
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: radius,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    IconTheme(
                      data: IconThemeData(color: fg, size: 18),
                      child: icon!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
