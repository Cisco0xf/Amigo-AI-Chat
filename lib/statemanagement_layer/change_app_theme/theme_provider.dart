import 'dart:developer';

import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/data_layer/save_last_data/save_prefs.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = true;

  Future<void> switchTheme(bool theme) async {
    isDark = theme;
    switchColors();

    await ThemeCashing.putThemeInCash(theme: theme);

    notifyListeners();
  }

  void switchColors() {
    if (isDark) {
      SwitchColors.secondary = DarkColors.secondary;
      SwitchColors.bgColor = DarkColors.bgColor;
      SwitchColors.primary = DarkColors.primary;
      SwitchColors.accent = DarkColors.accent;
      SwitchColors.border = DarkColors.border;
      SwitchColors.text = DarkColors.text;
      SwitchColors.opcColor = DarkColors.opcColor;
    } else {
      SwitchColors.secondary = LightColors.secondary;
      SwitchColors.bgColor = LightColors.bgColor;
      SwitchColors.primary = LightColors.primary;
      SwitchColors.accent = LightColors.accent;
      SwitchColors.border = LightColors.border;
      SwitchColors.text = LightColors.text;
      SwitchColors.opcColor = LightColors.opcColor;
    }
    notifyListeners();
  }

  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  void initializeThemeFromCashe(bool theme) {
    isDark = theme;
    switchColors();
  }
}
