import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/features/shared/data/repositories/course_repository.dart';
import 'package:thaheen_lms/features/shared/logic/app_exception.dart';
import 'course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  CourseDetailsCubit(this._courseRepository) : super(CourseDetailsInitial());

  final CourseRepository _courseRepository;

  Future<void> loadCourseDetails(String courseId) async {
    emit(CourseDetailsLoading());
    try {
      final data = await _courseRepository.getCourseDetails(courseId);
      final hasLessons = data.sections.any((s) => s.lessons.isNotEmpty);
      if (!hasLessons) {
        emit(CourseDetailsEmpty());
        return;
      }
      emit(CourseDetailsLoaded(data));
    } on AppException catch (e) {
      emit(CourseDetailsError(e.message));
    } catch (_) {
      emit(CourseDetailsError(AppStrings.generalError));
    }
  }
}
