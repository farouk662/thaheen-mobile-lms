import 'dart:convert';
import 'package:flutter/services.dart';

abstract final class AppStrings {
  static const String _arPath = 'assets/translations/ar.json';
  static const String _enPath = 'assets/translations/en.json';

  static Map<String, String> _ar = const {};
  static Map<String, String> _en = const {};
  static String _currentLocale = 'ar';

  /// Preloads translations from JSON assets into memory.
  static Future<void> init([String initialLocale = 'ar']) async {
    _currentLocale = initialLocale;
    try {
      final arJson = await rootBundle.loadString(_arPath);
      final enJson = await rootBundle.loadString(_enPath);
      final decodedAr = json.decode(arJson) as Map<String, dynamic>;
      final decodedEn = json.decode(enJson) as Map<String, dynamic>;

      _ar = decodedAr.map((k, v) => MapEntry(k, v.toString()));
      _en = decodedEn.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      // In case assets aren't available (e.g. headless tests), fallbacks remain intact
    }
  }

  /// Sets the active locale code ('ar' or 'en') synchronously.
  static void setLocale(String langCode) {
    _currentLocale = langCode;
  }

  static String get currentLocale => _currentLocale;
  static bool get isEnglish => _currentLocale == 'en';

  /// Translates a key according to the active locale with Arabic fallback.
  static String tr(String key) {
    final activeMap = _currentLocale == 'en' ? _en : _ar;
    return activeMap[key] ?? _ar[key] ?? key;
  }

  // ── Typed Getters ──────────────────────────────────────────────────────────
  static String get appTitle => tr('appTitle');
  static String get myCoursesTitle => tr('myCoursesTitle');
  static String get continueWatching => tr('continueWatching');
  static String get noCourses => tr('noCourses');
  static String get retry => tr('retry');
  static String get lockedLessonMessage => tr('lockedLessonMessage');
  static String get lessons => tr('lessons');
  static String get courseDetailsTitle => tr('courseDetailsTitle');
  static String get instructor => tr('instructor');
  static String get lessonNotStarted => tr('lessonNotStarted');
  static String get lessonInProgress => tr('lessonInProgress');
  static String get lessonCompleted => tr('lessonCompleted');
  static String get progressLabel => tr('progressLabel');
  static String get noLessons => tr('noLessons');
  static String get nextLesson => tr('nextLesson');
  static String get playbackSpeed => tr('playbackSpeed');
  static String get videoError => tr('videoError');
  static String get lessonCompletedNotice => tr('lessonCompletedNotice');
  static String get noNextLesson => tr('noNextLesson');
  static String get courseNotFound => tr('courseNotFound');
  static String get lessonNotFound => tr('lessonNotFound');
  static String get loadCoursesError => tr('loadCoursesError');
  static String get generalError => tr('generalError');
  static String get searchHint => tr('searchHint');
  static String get noSearchResults => tr('noSearchResults');
  static String get clearSearch => tr('clearSearch');
  static String get lessonNotes => tr('lessonNotes');
  static String get notesHint => tr('notesHint');
  static String get noteSaved => tr('noteSaved');
  static String get noteSaving => tr('noteSaving');
  static String get saveNote => tr('saveNote');
  static String get noteSavedSuccess => tr('noteSavedSuccess');
  static String get addNote => tr('addNote');
  static String get newNoteHint => tr('newNoteHint');
  static String get noNotesYet => tr('noNotesYet');
  static String get deleteNote => tr('deleteNote');
}
