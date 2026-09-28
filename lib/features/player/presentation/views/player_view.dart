import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/services/get_it_service.dart';
import '../manager/player_cubit.dart';
import '../widgets/player_app_bar.dart';
import '../widgets/player_view_body.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key, required this.courseId, required this.lessonId});

  final String courseId;
  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlayerCubit>()..loadLessonPlayer(courseId: courseId, lessonId: lessonId),
      child: Scaffold(
        appBar: const PlayerAppBar(),
        body: PlayerViewBody(courseId: courseId, lessonId: lessonId),
      ),
    );
  }
}
