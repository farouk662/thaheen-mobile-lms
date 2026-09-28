import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.color});

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final IconData iconData;
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // Cupertino back chevron (points right in RTL, left in LTR)
        iconData = isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // Material arrow (auto-mirrors in RTL)
        iconData = Icons.arrow_back_rounded;
        break;
    }

    return IconButton(
      icon: Icon(iconData, color: color),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}
