import 'package:flutter/material.dart';
import 'package:thaheen_lms/features/shared/data/models/course.dart';
import 'package:thaheen_lms/features/shared/data/models/lesson.dart';
import 'continue_watching_card.dart';

class ContinueWatchingSliver extends StatelessWidget {
  const ContinueWatchingSliver({
    super.key,
    required this.lesson,
    required this.parentCourse,
    required this.progress,
    required this.onTap,
  });

  final Lesson lesson;
  final Course parentCourse;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      sliver: SliverToBoxAdapter(
        child: ContinueWatchingCard(
          lesson: lesson,
          parentCourse: parentCourse,
          progress: progress,
          onTap: onTap,
        ),
      ),
    );
  }
}
