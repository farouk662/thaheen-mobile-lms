import 'package:go_router/go_router.dart';
import '../../features/course_details/presentation/views/course_details_view.dart';
import '../../features/courses/presentation/views/courses_view.dart';
import '../../features/player/presentation/views/player_view.dart';

abstract final class AppRouter {
  static const String courses = '/';
  static const String courseDetails = '/course-details';
  static const String player = '/player';

  static final GoRouter router = GoRouter(
    initialLocation: courses,
    routes: [
      GoRoute(
        path: courses,
        builder: (context, state) => const CoursesView(),
      ),
      GoRoute(
        path: courseDetails,
        builder: (context, state) => CourseDetailsView(
          courseId: state.extra as String,
        ),
      ),
      GoRoute(
        path: player,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PlayerView(
            courseId: extra['courseId'] as String? ?? '',
            lessonId: extra['lessonId'] as String? ?? '',
          );
        },
      ),
    ],
  );
}
