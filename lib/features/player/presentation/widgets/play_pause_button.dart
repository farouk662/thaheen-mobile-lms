import 'package:flutter/material.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.onPressed,
  });

  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 58,
      color: Colors.white,
      icon: Icon(
        isPlaying
            ? Icons.pause_circle_filled_rounded
            : Icons.play_circle_filled_rounded,
      ),
      onPressed: onPressed,
    );
  }
}
