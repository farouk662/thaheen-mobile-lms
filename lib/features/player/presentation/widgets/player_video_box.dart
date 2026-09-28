import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/features/shared/logic/progress_rules.dart';
import 'package:video_player/video_player.dart';
import '../manager/player_cubit.dart';
import 'player_controls_overlay.dart';
import 'player_video_error.dart';

class PlayerVideoBox extends StatefulWidget {
  const PlayerVideoBox({
    super.key,
    required this.lessonId,
    required this.videoUrl,
    required this.initialPositionSec,
    required this.playbackSpeed,
    required this.onRetry,
  });

  final String lessonId;
  final String videoUrl;
  final int initialPositionSec;
  final double playbackSpeed;
  final VoidCallback onRetry;

  @override
  State<PlayerVideoBox> createState() => _PlayerVideoBoxState();
}

class _PlayerVideoBoxState extends State<PlayerVideoBox> with WidgetsBindingObserver {
  late final PlayerCubit _cubit;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  DateTime _lastSaveTime = DateTime.now();
  bool _completionNotified = false;
  bool _hasError = false;

  bool get _isReady => _chewieController != null;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PlayerCubit>();
    WidgetsBinding.instance.addObserver(this);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _completionNotified = false;
    _hasError = false;
    if (mounted) setState(() {});
    _disposeControllers();

    try {
      final controller = await _buildVideoController();
      final chewie = _buildChewieController(controller);

      _videoController = controller;
      _chewieController = chewie;

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('PlayerVideoBox: failed to initialize — $e');
      _hasError = true;
      if (mounted) setState(() {});
    }
  }

  /// Creates, initializes, and seeks the [VideoPlayerController].
  Future<VideoPlayerController> _buildVideoController() async {
    final controller = VideoPlayerController.asset(widget.videoUrl);
    await controller.initialize();

    final duration = controller.value.duration.inSeconds;
    if (widget.initialPositionSec > 0 && widget.initialPositionSec < duration) {
      await controller.seekTo(Duration(seconds: widget.initialPositionSec));
    } else {
      await controller.seekTo(Duration.zero);
    }

    await controller.setPlaybackSpeed(widget.playbackSpeed);
    controller.addListener(_onVideoTick);
    return controller;
  }

  /// Wraps an initialized [VideoPlayerController] in a [ChewieController].
  ChewieController _buildChewieController(VideoPlayerController controller) {
    return ChewieController(
      videoPlayerController: controller,
      autoPlay: true,
      customControls: const PlayerControlsOverlay(),
      deviceOrientationsOnEnterFullScreen: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: const [
        DeviceOrientation.portraitUp,
      ],
      errorBuilder: (_, __) => PlayerVideoError(message: AppStrings.videoError, onRetry: widget.onRetry),
    );
  }

  void _onVideoTick() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;

    final positionSec = controller.value.position.inSeconds;
    final durationSec = controller.value.duration.inSeconds;
    final isCompleted = durationSec > 0 &&
        (controller.value.position >= controller.value.duration ||
            isLessonCompleted(positionSec, durationSec));

    final now = DateTime.now();
    final timePassed = now.difference(_lastSaveTime).inSeconds >= 2;
    final isNewCompletion = isCompleted && !_completionNotified;

    if (!timePassed && !isNewCompletion) return;
    _lastSaveTime = now;
    if (isCompleted) _completionNotified = true;

    _cubit.onPositionChanged(
      lessonId: widget.lessonId,
      positionSec: positionSec,
      durationSec: durationSec,
    );
  }

  void _saveProgress() {
    final controller = _videoController;
    if (controller == null || !controller.value.isInitialized) return;
    _cubit.saveCurrentProgress(
      lessonId: widget.lessonId,
      positionSec: controller.value.position.inSeconds,
      durationSec: controller.value.duration.inSeconds,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      _saveProgress();
    }
  }

  @override
  void didUpdateWidget(PlayerVideoBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lessonId != widget.lessonId || oldWidget.videoUrl != widget.videoUrl) {
      _initializePlayer();
    } else if (oldWidget.playbackSpeed != widget.playbackSpeed) {
      _videoController?.setPlaybackSpeed(widget.playbackSpeed);
    }
  }

  void _disposeControllers() {
    _videoController?.removeListener(_onVideoTick);
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  void dispose() {
    _saveProgress();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      color: Colors.black,
      constraints: BoxConstraints(
        maxHeight: isLandscape ? screenHeight * 0.45 : double.infinity,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _hasError
            ? PlayerVideoError(
                message: AppStrings.videoError,
                onRetry: () {
                  widget.onRetry();
                  _initializePlayer();
                },
              )
            : _isReady
                ? Chewie(controller: _chewieController!)
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
