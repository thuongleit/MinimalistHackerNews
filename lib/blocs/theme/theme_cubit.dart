import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/colors.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  static const _prefKey = 'theme';

  ThemeCubit() : super(SystemTheme());

  void updateTheme(ThemeState theme) => emit(theme);

  @override
  ThemeState fromJson(Map<String, dynamic> json) {
    final themeCode = json[_prefKey] as String;
    switch (themeCode) {
      case 'system':
        return SystemTheme();
      case 'black':
        return BlackTheme();
      case 'dark':
        return DarkTheme();
      case 'light':
        return LightTheme();
      default:
        return SystemTheme();
    }
  }

  @override
  Map<String, dynamic> toJson(ThemeState state) {
    return <String, String>{_prefKey: state.themeCode};
  }
}

extension on ThemeState {
  String get themeCode {
    switch (runtimeType) {
      case SystemTheme:
        return 'system';
      case BlackTheme:
        return 'black';
      case DarkTheme:
        return 'dark';
      case LightTheme:
        return 'light';
      default:
        return 'system';
    }
  }
}