import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isEnglish {
    try {
      return Localizations.localeOf(this).languageCode == 'en';
    } catch (_) {
      return false;
    }
  }
}
