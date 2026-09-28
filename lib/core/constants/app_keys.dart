abstract final class AppKeys {
  // ── Hive Box Names ───────────────────────────────────────
  static const String progressBox = 'progress';

  // ── Preference / Settings Keys ───────────────────────────
  static const String localeCode = 'locale_code';
  static const String themeMode = 'theme_mode';
  static const String playbackSpeed = 'playback_speed';

  // ── Lesson Progress Map Keys ─────────────────────────────
  static const String positionSec = 'positionSec';
  static const String completed = 'completed';
  static const String lastWatchedAt = 'lastWatchedAt';

  // ── Lesson Notes Keys ────────────────────────────────────
  static String lessonNoteKey(String lessonId) => 'note_$lessonId';
  static String lessonNotesListKey(String lessonId) => 'notes_list_$lessonId';
}
