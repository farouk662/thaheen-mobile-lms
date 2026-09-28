import 'package:hive/hive.dart';
import '../../../../core/constants/app_keys.dart';

/// Progress record stored per lessonId key.
/// Map shape: { AppKeys.positionSec: int, AppKeys.completed: bool, AppKeys.lastWatchedAt: int }
class ProgressLocalDataSource {
  const ProgressLocalDataSource(this._progressBox);

  final Box _progressBox;

  Map<String, dynamic>? getProgress(String lessonId) {
    final raw = _progressBox.get(lessonId);
    if (raw == null || raw is! Map) return null;
    return Map<String, dynamic>.from(raw);
  }

  Future<void> saveProgress({required String lessonId, required int positionSec, required bool completed}) async {
    await _progressBox.put(lessonId, {
      AppKeys.positionSec: positionSec,
      AppKeys.completed: completed,
      AppKeys.lastWatchedAt: DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Returns all lesson IDs whose 'completed' flag is true.
  List<String> getCompletedLessonIds() {
    return _progressBox.keys.whereType<String>().where((key) {
      final raw = _progressBox.get(key);
      if (raw is! Map) return false;
      final map = Map<String, dynamic>.from(raw);
      return map[AppKeys.completed] == true;
    }).toList();
  }

  /// Returns the lesson ID that was most recently watched but not yet completed
  /// (0 < positionSec < durationSec), along with its lastWatchedAt timestamp.
  ({String lessonId, int positionSec, int lastWatchedAt})? getMostRecentInProgress(
    List<String> lessonIds,
    Map<String, int> lessonDurations,
  ) {
    ({String lessonId, int positionSec, int lastWatchedAt})? best;

    for (final lessonId in lessonIds) {
      if (!lessonDurations.containsKey(lessonId)) continue;
      final raw = _progressBox.get(lessonId);
      if (raw is! Map) continue;
      final map = Map<String, dynamic>.from(raw);
      final positionSec = (map[AppKeys.positionSec] as int?) ?? 0;
      final lastWatchedAt = (map[AppKeys.lastWatchedAt] as int?) ?? 0;
      final completed = (map[AppKeys.completed] as bool?) ?? false;
      final durationSec = lessonDurations[lessonId]!;

      if (!completed && positionSec > 0 && positionSec < durationSec) {
        if (best == null || lastWatchedAt > best.lastWatchedAt) {
          best = (lessonId: lessonId, positionSec: positionSec, lastWatchedAt: lastWatchedAt);
        }
      }
    }
    return best;
  }

  double getPreferredPlaybackSpeed() {
    final raw = _progressBox.get(AppKeys.playbackSpeed);
    if (raw is num) return raw.toDouble();
    return 1.0;
  }

  Future<void> savePreferredPlaybackSpeed(double speed) async {
    await _progressBox.put(AppKeys.playbackSpeed, speed);
  }
}
