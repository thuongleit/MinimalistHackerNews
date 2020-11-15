import 'dart:wasm';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/colors.dart';

part 'theme_state.dart';

enum AppTheme { system, light, dark, black }

class ThemeCubit extends HydratedCubit<AppTheme> {
  static const _prefKey = 'theme';

  ThemeCubit() : super(AppTheme.system);

  void updateTheme(AppTheme theme) => emit(theme);

  @override
  AppTheme fromJson(Map<String, dynamic> json) {
    final index = json[_prefKey] as int;
    return AppTheme.values[index];
  }

  @override
  Map<String, dynamic> toJson(AppTheme state) {
    return <String, int>{_prefKey: state.index};
  }
}

extension AppThemeToThemeState on AppTheme {
  ThemeState get value {
    final theme = AppTheme.values[index];
    switch (theme) {
      case AppTheme.system:
        return SystemTheme();
      case AppTheme.light:
        return LightTheme();
      case AppTheme.dark:
        return DarkTheme();
      case AppTheme.black:
        return BlackTheme();
      default:
        return SystemTheme();
    }
  }
}
