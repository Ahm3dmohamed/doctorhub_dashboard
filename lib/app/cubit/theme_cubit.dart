import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the application's light/dark theme mode.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  /// Toggle between light and dark mode.
  void toggle() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  bool get isDark => state == ThemeMode.dark;
}
