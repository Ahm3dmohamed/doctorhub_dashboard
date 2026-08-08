import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages application locale (en / ar) with SharedPreferences persistence.
class LocaleCubit extends Cubit<Locale> {
  static const String _localeKey = 'app_locale';
  final SharedPreferences? _prefs;

  LocaleCubit([this._prefs]) : super(const Locale('en')) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final langCode = _prefs?.getString(_localeKey);
    if (langCode != null && (langCode == 'en' || langCode == 'ar')) {
      emit(Locale(langCode));
    }
  }

  /// Change to a specific locale and persist selection.
  Future<void> setLocale(Locale newLocale) async {
    if (state == newLocale) return;
    emit(newLocale);
    await _prefs?.setString(_localeKey, newLocale.languageCode);
  }

  /// Toggle between English and Arabic.
  Future<void> toggle() async {
    final next = isArabic ? const Locale('en') : const Locale('ar');
    await setLocale(next);
  }

  bool get isArabic => state.languageCode == 'ar';
}
