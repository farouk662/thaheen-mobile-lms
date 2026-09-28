import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';

class CoursesAppBarTitle extends StatelessWidget {
  const CoursesAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.myCoursesTitle,
      style: AppTextStyles.title.copyWith(
        color: context.colorScheme.onSurface,
      ),
    );
  }
}
