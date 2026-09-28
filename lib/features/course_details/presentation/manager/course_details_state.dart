import 'package:equatable/equatable.dart';
import 'package:thaheen_lms/features/shared/data/models/course_details_data.dart';

sealed class CourseDetailsState extends Equatable {
  const CourseDetailsState();

  @override
  List<Object?> get props => [];
}

class CourseDetailsInitial extends CourseDetailsState {}

class CourseDetailsLoading extends CourseDetailsState {}

class CourseDetailsEmpty extends CourseDetailsState {}

class CourseDetailsLoaded extends CourseDetailsState {
  const CourseDetailsLoaded(this.data);

  final CourseDetailsData data;

  @override
  List<Object?> get props => [data];
}

class CourseDetailsError extends CourseDetailsState {
  const CourseDetailsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
