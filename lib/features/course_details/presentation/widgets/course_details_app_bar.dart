import 'package:flutter/material.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/app_strings.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';
import 'package:thaheen_lms/core/widgets/adaptive/app_back_button.dart';

class CourseDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CourseDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.courseDetailsTitle,
        style: AppTextStyles.title.copyWith(
          color: context.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      leading: const AppBackButton(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
