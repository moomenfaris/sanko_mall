import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/di/service_locator.dart';

/// Holds user-selectable app settings: theme mode and locale.
class AppSettings {
  const AppSettings({required this.themeMode, required this.locale});

  final ThemeMode themeMode;
  final Locale locale;

  AppSettings copyWith({ThemeMode? themeMode, Locale? locale}) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
  );
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._prefs)
    : super(
        AppSettings(
          themeMode: _readTheme(_prefs),
          locale: Locale(_prefs.getString(AppConstants.prefLocale) ?? 'ar'),
        ),
      );

  final SharedPreferences _prefs;

  static ThemeMode _readTheme(SharedPreferences prefs) {
    switch (prefs.getString(AppConstants.prefThemeMode)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    _prefs.setString(AppConstants.prefThemeMode, next.name);
    state = state.copyWith(themeMode: next);
  }

  void toggleLocale() {
    final next = state.locale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    _prefs.setString(AppConstants.prefLocale, next.languageCode);
    state = state.copyWith(locale: next);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  return SettingsNotifier(sl<SharedPreferences>());
});
