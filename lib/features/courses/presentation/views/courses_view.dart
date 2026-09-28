import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/services/get_it_service.dart';
import '../manager/courses_cubit.dart';
import '../widgets/courses_app_bar.dart';
import '../widgets/courses_view_body.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CoursesCubit>()..loadCourses(),
      child: const Scaffold(
        appBar: CoursesAppBar(),
        body: CoursesViewBody(),
      ),
    );
  }
}
