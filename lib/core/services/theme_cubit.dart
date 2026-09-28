import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../constants/app_keys.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._box) : super(_initialThemeMode(_box));

  final Box _box;

  static ThemeMode _initialThemeMode(Box box) {
    final savedMode = box.get(AppKeys.themeMode);
    return switch (savedMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  void toggle() {
    final isDark = state == ThemeMode.dark;
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final nextString = isDark ? 'light' : 'dark';

    _box.put(AppKeys.themeMode, nextString);
    emit(nextMode);
  }
}
