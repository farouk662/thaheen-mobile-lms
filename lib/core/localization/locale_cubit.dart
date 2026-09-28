import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../constants/app_keys.dart';
import 'app_strings.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._box) : super(_initialLocale(_box)) {
    AppStrings.setLocale(state.languageCode);
  }

  final Box _box;

  static Locale _initialLocale(Box box) {
    final savedCode = box.get(AppKeys.localeCode);
    return savedCode == 'en' ? const Locale('en') : const Locale('ar');
  }

  void toggleLocale() {
    final isAr = state.languageCode == 'ar';
    final nextCode = isAr ? 'en' : 'ar';

    _box.put(AppKeys.localeCode, nextCode);
    AppStrings.setLocale(nextCode);
    emit(Locale(nextCode));
  }

  void setLocale(String langCode) {
    if (state.languageCode == langCode) return;
    _box.put(AppKeys.localeCode, langCode);
    AppStrings.setLocale(langCode);
    emit(Locale(langCode));
  }
}
