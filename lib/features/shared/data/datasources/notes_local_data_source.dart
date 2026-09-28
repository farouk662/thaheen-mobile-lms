import 'package:hive/hive.dart';
import '../../../../core/constants/app_keys.dart';
import '../models/lesson_note.dart';

class NotesLocalDataSource {
  const NotesLocalDataSource(this._box);

  final Box _box;

  String getLessonNote(String lessonId) {
    final raw = _box.get(AppKeys.lessonNoteKey(lessonId));
    if (raw is String) return raw;
    return '';
  }

  Future<void> saveLessonNote({required String lessonId, required String note}) async {
    final key = AppKeys.lessonNoteKey(lessonId);
    if (note.trim().isEmpty) {
      await _box.delete(key);
    } else {
      await _box.put(key, note);
    }
  }

  List<LessonNote> getLessonNotes(String lessonId) {
    final raw = _box.get(AppKeys.lessonNotesListKey(lessonId));
    if (raw is! List) {
      final legacy = _box.get(AppKeys.lessonNoteKey(lessonId));
      if (legacy is String && legacy.trim().isNotEmpty) {
        return [
          LessonNote(
            id: '${lessonId}_legacy',
            text: legacy.trim(),
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        ];
      }
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((m) => LessonNote.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<void> addLessonNote({required String lessonId, required String text}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final notes = getLessonNotes(lessonId).toList();
    final newNote = LessonNote(
      id: '${lessonId}_${DateTime.now().millisecondsSinceEpoch}',
      text: trimmed,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    notes.insert(0, newNote);
    await _box.put(
      AppKeys.lessonNotesListKey(lessonId),
      notes.map((n) => n.toJson()).toList(),
    );
  }

  Future<void> deleteLessonNote({required String lessonId, required String noteId}) async {
    final notes = getLessonNotes(lessonId).where((n) => n.id != noteId).toList();
    if (notes.isEmpty) {
      await _box.delete(AppKeys.lessonNotesListKey(lessonId));
      await _box.delete(AppKeys.lessonNoteKey(lessonId));
    } else {
      await _box.put(
        AppKeys.lessonNotesListKey(lessonId),
        notes.map((n) => n.toJson()).toList(),
      );
    }
  }
}
