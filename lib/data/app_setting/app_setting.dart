import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppSetting {
  const AppSetting({@required this.themeMode});

  factory AppSetting.fromJson(Map<String, dynamic> json) => _fromJson(json);

  final ThemeMode themeMode;

  Map<String, dynamic> toJson() {
    return <String, String>{
      'themeMode': _themeModeToString(themeMode),
    };
  }

  // ignore: prefer_constructors_over_static_methods
  static AppSetting _fromJson(Map<String, dynamic> json) {
    return AppSetting(
      themeMode: _stringToThemeMode(json['themeMode'] as String),
    );
  }

  static String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
    return '';
  }

  static ThemeMode _stringToThemeMode(String string) {
    switch (string) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }
}
