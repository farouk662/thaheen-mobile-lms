import 'package:flutter/material.dart';
import 'courses_search_bar.dart';

class CoursesSearchBarSliver extends StatelessWidget {
  const CoursesSearchBarSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
      sliver: SliverToBoxAdapter(
        child: CoursesSearchBar(),
      ),
    );
  }
}
