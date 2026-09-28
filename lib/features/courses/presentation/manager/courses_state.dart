import 'package:equatable/equatable.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';

sealed class CoursesState extends Equatable {
  const CoursesState();
  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesEmpty extends CoursesState {}

class CoursesError extends CoursesState {
  const CoursesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class CoursesLoaded extends CoursesState {
  const CoursesLoaded({
    required this.courses,
    required this.completedLessonIds,
    this.searchQuery = '',
    this.continueWatchingLesson,
    this.continueWatchingCourse,
    this.continueWatchingProgress,
  });

  final List<Course> courses;
  final List<String> completedLessonIds;
  final String searchQuery;
  final Lesson? continueWatchingLesson;
  final Course? continueWatchingCourse;
  final double? continueWatchingProgress; // 0.0–1.0

  CoursesLoaded copyWith({
    List<Course>? courses,
    List<String>? completedLessonIds,
    String? searchQuery,
    Lesson? continueWatchingLesson,
    Course? continueWatchingCourse,
    double? continueWatchingProgress,
  }) {
    return CoursesLoaded(
      courses: courses ?? this.courses,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      searchQuery: searchQuery ?? this.searchQuery,
      continueWatchingLesson: continueWatchingLesson ?? this.continueWatchingLesson,
      continueWatchingCourse: continueWatchingCourse ?? this.continueWatchingCourse,
      continueWatchingProgress: continueWatchingProgress ?? this.continueWatchingProgress,
    );
  }

  @override
  List<Object?> get props => [
        courses,
        completedLessonIds,
        searchQuery,
        continueWatchingLesson,
        continueWatchingCourse,
        continueWatchingProgress,
      ];
}
