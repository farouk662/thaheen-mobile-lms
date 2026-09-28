import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/services/get_it_service.dart';
import '../manager/course_details_cubit.dart';
import '../widgets/course_details_app_bar.dart';
import '../widgets/course_details_view_body.dart';

class CourseDetailsView extends StatelessWidget {
  const CourseDetailsView({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseDetailsCubit>()..loadCourseDetails(courseId),
      child: Scaffold(
        appBar: const CourseDetailsAppBar(),
        body: CourseDetailsViewBody(courseId: courseId),
      ),
    );
  }
}
