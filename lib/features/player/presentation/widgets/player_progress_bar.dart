import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/theme/app_colors.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:video_player/video_player.dart';

class PlayerProgressBar extends StatefulWidget {
  const PlayerProgressBar({
    super.key,
    required this.controller,
    required this.onSeek,
  });

  final VideoPlayerController controller;
  final ValueChanged<Duration> onSeek;

  @override
  State<PlayerProgressBar> createState() => _PlayerProgressBarState();
}

class _PlayerProgressBarState extends State<PlayerProgressBar> {
  double? _dragValue;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant PlayerProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdate);
      widget.controller.addListener(_onControllerUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    // Only rebuild from the controller tick when not dragging.
    if (mounted && _dragValue == null) setState(() {});
  }

  static String _format(Duration duration) {
    final totalSec = duration.inSeconds;
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final totalSec = value.duration.inSeconds.toDouble();
    final max = totalSec > 0 ? totalSec : 1.0;
    final currentSec = (_dragValue ?? value.position.inSeconds.toDouble()).clamp(0.0, max);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: AppColors.accent.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: currentSec,
            max: max,
            onChangeStart: (val) => setState(() => _dragValue = val),
            onChanged: (val) => setState(() => _dragValue = val),
            onChangeEnd: (val) {
              setState(() => _dragValue = null);
              widget.onSeek(Duration(seconds: val.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(Duration(seconds: currentSec.toInt())),
                style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 11),
              ),
              Text(
                _format(value.duration),
                style: AppTextStyles.caption.copyWith(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
