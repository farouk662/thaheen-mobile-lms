import 'package:flutter/material.dart';

class AppForwardIcon extends StatelessWidget {
  const AppForwardIcon({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.chevron_right_rounded, color: color, size: size ?? 20.0);
  }
}
