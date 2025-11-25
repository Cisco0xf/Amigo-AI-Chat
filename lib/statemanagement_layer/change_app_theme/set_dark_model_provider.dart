import 'dart:developer';

import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/data_layer/save_last_data/save_last_data.dart';
import 'package:flutter/material.dart';

class DarkModeProvider with ChangeNotifier {
  final SaveUserChanges saveAppMode = SaveAppMode();

  bool isDark = false;

  void get setDarkMode {
    isDark = !isDark;
    saveAppMode.putDataInDatabase(
      data: isDark,
    );
    setAppColors;
    notifyListeners();
  }

  Brightness get appBrightness {
    if (isDark) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  Future<void> get setAppColors async {
    bool isAppDark = await saveAppMode.getDataFromDatabase;
    if (isAppDark) {
      ColorsSwitcher.mainColor = AppColorsDarkMode.mainColor;
    } else {
      ColorsSwitcher.mainColor = AppColorsLighMode.mainColor;
    }

    notifyListeners();
  }

  Future<void> get initalizeAppMode async {
    bool isDarkFromDatabase = await saveAppMode.getDataFromDatabase;

    isDark = isDarkFromDatabase;

    setAppColors;

    log("IsDark : $isDark");

    notifyListeners();
  }
}
