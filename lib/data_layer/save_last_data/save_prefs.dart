import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/data_layer/save_last_data/prefs_keys.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCashing {
  static Future<void> putThemeInCash({required bool theme}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(PrefsKeys.THEME_KEY, theme);
  }

  static Future<bool> get catchThemeFromCash async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool db = prefs.getBool(PrefsKeys.THEME_KEY) ?? true;

    return db;
  }

  static Future<void> initThemeFromCashe(BuildContext context) async {
    final bool dbCashe = await catchThemeFromCash;

    navigatorKey.currentContext!
        .read<ThemeProvider>()
        .initializeThemeFromCashe(dbCashe);
  }
}

class InitUserPrefs {
  static Future<void> initCashes(BuildContext context) async {
    await ThemeCashing.initThemeFromCashe(context);
  }
}
