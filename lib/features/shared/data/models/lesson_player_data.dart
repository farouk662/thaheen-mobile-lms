import 'package:equatable/equatable.dart';
import 'course.dart';
import 'lesson.dart';

class LessonPlayerData extends Equatable {
  const LessonPlayerData({
    required this.course,
    required this.currentLesson,
    this.nextLesson,
    required this.isNextLessonUnlocked,
    required this.savedPositionSec,
    required this.isCompleted,
    required this.preferredSpeed,
  });

  final Course course;
  final Lesson currentLesson;
  final Lesson? nextLesson;
  final bool isNextLessonUnlocked;
  final int savedPositionSec;
  final bool isCompleted;
  final double preferredSpeed;

  LessonPlayerData copyWith({
    Course? course,
    Lesson? currentLesson,
    Lesson? nextLesson,
    bool? isNextLessonUnlocked,
    int? savedPositionSec,
    bool? isCompleted,
    double? preferredSpeed,
  }) {
    return LessonPlayerData(
      course: course ?? this.course,
      currentLesson: currentLesson ?? this.currentLesson,
      nextLesson: nextLesson ?? this.nextLesson,
      isNextLessonUnlocked: isNextLessonUnlocked ?? this.isNextLessonUnlocked,
      savedPositionSec: savedPositionSec ?? this.savedPositionSec,
      isCompleted: isCompleted ?? this.isCompleted,
      preferredSpeed: preferredSpeed ?? this.preferredSpeed,
    );
  }

  @override
  List<Object?> get props => [
        course.id,
        currentLesson.id,
        nextLesson?.id,
        isNextLessonUnlocked,
        savedPositionSec,
        isCompleted,
        preferredSpeed,
      ];
}
