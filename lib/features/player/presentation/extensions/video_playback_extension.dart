import 'package:video_player/video_player.dart';

/// Clean presentation extension encapsulating media playback control operations.
/// Keeps playback actions decoupled from [PlayerCubit] and eliminates duplicate math in widgets.
extension VideoPlaybackExtension on VideoPlayerController {
  static const Duration _seekStep = Duration(seconds: 10);

  /// Toggles between play and pause.
  void togglePlayPause() {
    value.isPlaying ? pause() : play();
  }

  /// Rewinds playback by 10 seconds, clamped to [Duration.zero].
  void seekBack() {
    final target = value.position - _seekStep;
    seekTo(target < Duration.zero ? Duration.zero : target);
  }

  /// Fast-forwards playback by 10 seconds, clamped to video duration.
  void seekForward() {
    final target = value.position + _seekStep;
    final max = value.duration;
    seekTo(target > max ? max : target);
  }

  /// Seeks to [position], clamped safely between zero and duration.
  void seekClamped(Duration position) {
    final max = value.duration;
    if (position > max) {
      seekTo(max);
    } else if (position < Duration.zero) {
      seekTo(Duration.zero);
    } else {
      seekTo(position);
    }
  }
}
