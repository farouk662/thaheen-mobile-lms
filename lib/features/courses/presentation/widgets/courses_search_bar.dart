import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/widgets/fields/app_text_field.dart';
import '../manager/courses_cubit.dart';

class CoursesSearchBar extends StatefulWidget {
  const CoursesSearchBar({super.key});

  @override
  State<CoursesSearchBar> createState() => _CoursesSearchBarState();
}

class _CoursesSearchBarState extends State<CoursesSearchBar> {
  late final TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    final hasText = query.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
    context.read<CoursesCubit>().searchCourses(query);
  }

  void _onClear() {
    _controller.clear();
    setState(() => _hasText = false);
    context.read<CoursesCubit>().searchCourses('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppTextField(
      controller: _controller,
      onChanged: _onChanged,
      hintText: AppStrings.searchHint,
      textInputAction: TextInputAction.search,
      prefixIcon: Icon(
        Icons.search_rounded,
        color: colorScheme.onSurfaceVariant,
        size: 22,
      ),
      suffixIcon: _hasText
          ? IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: _onClear,
              tooltip: AppStrings.clearSearch,
            )
          : null,
    );
  }
}
