import 'package:flutter/material.dart';
import '../../extensions/build_context_extension.dart';
import '../../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.minLines = 1,
    this.maxLines = 1,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType,
    this.fillColor,
    this.borderRadius = 14.0,
    this.contentPadding,
    this.focusNode,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bg = fillColor ?? colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        minLines: minLines,
        maxLines: maxLines,
        autofocus: autofocus,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: AppTextStyles.body.copyWith(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
