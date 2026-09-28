import 'package:flutter/material.dart';
import 'courses_app_bar_title.dart';
import 'language_toggle_button.dart';
import 'theme_toggle_button.dart';

class CoursesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoursesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CoursesAppBarTitle(),
      centerTitle: false,
      actions: const [
        LanguageToggleButton(),
        ThemeToggleButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
