import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_lms/core/extensions/build_context_extension.dart';
import 'package:thaheen_lms/core/localization/locale_cubit.dart';
import 'package:thaheen_lms/core/theme/app_text_styles.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return IconButton(
      icon: Text(
        isAr ? 'EN' : 'عربي',
        style: AppTextStyles.cardTitle.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
      onPressed: () => context.read<LocaleCubit>().toggleLocale(),
    );
  }
}
