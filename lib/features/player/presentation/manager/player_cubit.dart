import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson_note.dart';
import 'package:thaheen_lms/features/shared/data/repositories/course_repository.dart';
import 'package:thaheen_lms/features/shared/logic/app_exception.dart';
import 'package:thaheen_lms/features/shared/logic/progress_rules.dart';

import 'player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(this._courseRepository) : super(PlayerInitial());

  final CourseRepository _courseRepository;

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> loadLessonPlayer({
    required String courseId,
    required String lessonId,
  }) async {
    emit(PlayerLoading());
    try {
      final data = await _courseRepository.getLessonPlayerData(
        courseId: courseId,
        lessonId: lessonId,
      );
      emit(PlayerLoaded(data));
    } on AppException catch (e) {
      emit(PlayerError(e.message));
    } catch (_) {
      emit(PlayerError(AppStrings.generalError));
    }
  }

  // ── Progress tracking ─────────────────────────────────────────────────────

  void onPositionChanged({
    required String lessonId,
    required int positionSec,
    required int durationSec,
  }) {
    final currentState = state;
    if (currentState is! PlayerLoaded) return;

    final data = currentState.data;
    if (data.currentLesson.id != lessonId) return;

    final isCompleted =
        data.isCompleted || isLessonCompleted(positionSec, durationSec);

    _courseRepository.saveLessonProgress(
      lessonId: lessonId,
      positionSec: positionSec,
      completed: isCompleted,
    );

    if (isCompleted && !data.isCompleted) {
      emit(PlayerLoaded(data.copyWith(isCompleted: true, isNextLessonUnlocked: true)));
    }
  }

  void saveCurrentProgress({
    required String lessonId,
    required int positionSec,
    int? durationSec,
  }) {
    final currentState = state;
    if (currentState is! PlayerLoaded) {
      _courseRepository.saveLessonProgress(
        lessonId: lessonId,
        positionSec: positionSec,
        completed: false,
      );
      return;
    }

    final data = currentState.data;
    if (data.currentLesson.id != lessonId) {
      final duration = durationSec ?? 0;
      final isCompleted = duration > 0 && isLessonCompleted(positionSec, duration);
      _courseRepository.saveLessonProgress(
        lessonId: lessonId,
        positionSec: positionSec,
        completed: isCompleted,
      );
      return;
    }

    final duration = durationSec ?? data.currentLesson.durationSec;
    final isCompleted =
        data.isCompleted || isLessonCompleted(positionSec, duration);

    _courseRepository.saveLessonProgress(
      lessonId: lessonId,
      positionSec: positionSec,
      completed: isCompleted,
    );

    if (isCompleted && !data.isCompleted) {
      emit(PlayerLoaded(data.copyWith(isCompleted: true, isNextLessonUnlocked: true)));
    }
  }

  // ── Playback speed ────────────────────────────────────────────────────────

  Future<void> setPlaybackSpeed(double speed) async {
    final currentState = state;
    if (currentState is! PlayerLoaded) return;

    await _courseRepository.savePreferredPlaybackSpeed(speed);
    emit(PlayerLoaded(currentState.data.copyWith(preferredSpeed: speed)));
  }

  // ── Lesson notes ──────────────────────────────────────────────────────────

  List<LessonNote> getLessonNotes(String lessonId) {
    return _courseRepository.getLessonNotes(lessonId);
  }

  Future<void> addLessonNote({required String lessonId, required String text}) async {
    await _courseRepository.addLessonNote(
      lessonId: lessonId,
      text: text,
    );
  }

  Future<void> deleteLessonNote({required String lessonId, required String noteId}) async {
    await _courseRepository.deleteLessonNote(
      lessonId: lessonId,
      noteId: noteId,
    );
  }
}
