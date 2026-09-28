import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:thaheen_lms/core/constants/app_keys.dart';
import 'package:thaheen_lms/core/localization/locale_cubit.dart';
import 'package:thaheen_lms/core/services/theme_cubit.dart';
import 'package:thaheen_lms/features/course_details/presentation/manager/course_details_cubit.dart';
import 'package:thaheen_lms/features/courses/presentation/manager/courses_cubit.dart';
import 'package:thaheen_lms/features/player/presentation/manager/player_cubit.dart';
import 'package:thaheen_lms/features/shared/data/datasources/courses_local_data_source.dart';
import 'package:thaheen_lms/features/shared/data/datasources/notes_local_data_source.dart';
import 'package:thaheen_lms/features/shared/data/datasources/progress_local_data_source.dart';
import 'package:thaheen_lms/features/shared/data/repositories/course_repository.dart';

final getIt = GetIt.instance;

void setupGetItService() {
  // ── Services ─────────────────────────────────────────────
  getIt.registerLazySingleton<Box>(() => Hive.box(AppKeys.progressBox));

  // ── Data sources ─────────────────────────────────────────
  getIt.registerLazySingleton<CoursesLocalDataSource>(() => CoursesLocalDataSource());
  getIt.registerLazySingleton<ProgressLocalDataSource>(() => ProgressLocalDataSource(getIt<Box>()));
  getIt.registerLazySingleton<NotesLocalDataSource>(() => NotesLocalDataSource(getIt<Box>()));

  // ── Repositories ─────────────────────────────────────────
  getIt.registerLazySingleton<CourseRepository>(() => CourseRepository(getIt(), getIt(), getIt()));

  // ── Cubits ───────────────────────────────────────────────
  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt<Box>()));
  getIt.registerFactory<LocaleCubit>(() => LocaleCubit(getIt<Box>()));
  getIt.registerFactory<CoursesCubit>(() => CoursesCubit(getIt<CourseRepository>()));
  getIt.registerFactory<CourseDetailsCubit>(() => CourseDetailsCubit(getIt<CourseRepository>()));
  getIt.registerFactory<PlayerCubit>(() => PlayerCubit(getIt<CourseRepository>()));
}
