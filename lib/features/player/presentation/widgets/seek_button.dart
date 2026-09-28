import 'package:flutter/material.dart';

class SeekButton extends StatelessWidget {
  const SeekButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 34,
      color: Colors.white,
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
