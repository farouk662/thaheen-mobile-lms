import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/repositories/course_repository.dart';
import 'package:thaheen_lms/features/shared/logic/app_exception.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit(this._courseRepository) : super(CoursesInitial());

  final CourseRepository _courseRepository;
  List<Course> _allCourses = const [];
  String _currentQuery = '';

  Future<void> loadCourses() async {
    emit(CoursesLoading());
    try {
      final data = await _courseRepository.getCoursesData();
      if (data.courses.isEmpty) {
        emit(CoursesEmpty());
        return;
      }
      _allCourses = data.courses;
      final displayedCourses = _filterCourses(_currentQuery);
      emit(
        CoursesLoaded(
          courses: displayedCourses,
          completedLessonIds: data.completedLessonIds,
          searchQuery: _currentQuery,
          continueWatchingLesson: data.continueWatchingLesson,
          continueWatchingCourse: data.continueWatchingCourse,
          continueWatchingProgress: data.continueWatchingProgress,
        ),
      );
    } on AppException catch (e) {
      emit(CoursesError(e.message));
    } catch (_) {
      emit(CoursesError(AppStrings.generalError));
    }
  }

  void searchCourses(String query) {
    _currentQuery = query;
    final currentState = state;
    if (currentState is! CoursesLoaded) return;

    final filtered = _filterCourses(query);
    emit(currentState.copyWith(courses: filtered, searchQuery: query));
  }

  List<Course> _filterCourses(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return _allCourses;

    return _allCourses.where((course) {
      final matchesTitleAr = course.title.toLowerCase().contains(trimmed);
      final matchesTitleEn = course.titleEn?.toLowerCase().contains(trimmed) ?? false;
      final matchesInstructorAr = course.instructor.toLowerCase().contains(trimmed);
      final matchesInstructorEn = course.instructorEn?.toLowerCase().contains(trimmed) ?? false;
      return matchesTitleAr || matchesTitleEn || matchesInstructorAr || matchesInstructorEn;
    }).toList();
  }
}
