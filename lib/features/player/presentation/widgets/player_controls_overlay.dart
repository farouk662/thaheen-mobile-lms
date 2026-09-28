import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../extensions/video_playback_extension.dart';
import 'play_pause_button.dart';
import 'player_progress_bar.dart';
import 'seek_button.dart';

class PlayerControlsOverlay extends StatefulWidget {
  const PlayerControlsOverlay({super.key});

  @override
  State<PlayerControlsOverlay> createState() => _PlayerControlsOverlayState();
}

class _PlayerControlsOverlayState extends State<PlayerControlsOverlay> {
  static const _kHideDuration = Duration(seconds: 3);

  bool _isVisible = true;
  Timer? _hideTimer;

  // Cached to manage the listener safely across dependency changes and disposal.
  VideoPlayerController? _controller;

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newController = ChewieController.of(context).videoPlayerController;
    if (_controller != newController) {
      _controller?.removeListener(_onControllerUpdate);
      _controller = newController..addListener(_onControllerUpdate);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(_kHideDuration, () {
      if (mounted) setState(() => _isVisible = false);
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _startHideTimer();
      } else {
        _hideTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);
    final controller = chewieController.videoPlayerController;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleVisibility,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: ColoredBox(
          color: _isVisible ? Colors.black38 : Colors.transparent,
          child: Stack(
            children: [
              // ── Center: Rewind · Play/Pause · Forward ───────────────────
              // Shifted slightly above geometric center to visually clear the
              // progress bar at the bottom.
              Align(
                alignment: const Alignment(0, -0.2),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SeekButton(
                        icon: Icons.replay_10_rounded,
                        onPressed: () {
                          controller.seekBack();
                          _startHideTimer();
                        },
                      ),
                      const SizedBox(width: 24),
                      PlayPauseButton(
                        isPlaying: controller.value.isPlaying,
                        onPressed: () {
                          controller.togglePlayPause();
                          _startHideTimer();
                        },
                      ),
                      const SizedBox(width: 24),
                      SeekButton(
                        icon: Icons.forward_10_rounded,
                        onPressed: () {
                          controller.seekForward();
                          _startHideTimer();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom-right: Fullscreen (floats above the progress bar) ─
              Positioned(
                right: 4,
                bottom: 35,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    chewieController.isFullScreen
                        ? Icons.fullscreen_exit_rounded
                        : Icons.fullscreen_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () {
                    chewieController.toggleFullScreen();
                    _startHideTimer();
                  },
                ),
              ),

              // ── Bottom: Progress bar (LTR — fills left → right) ─────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PlayerProgressBar(
                    controller: controller,
                    onSeek: (pos) {
                      controller.seekClamped(pos);
                      _startHideTimer();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
