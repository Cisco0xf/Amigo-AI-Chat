import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension IsDark on BuildContext {
  bool get isDark {
    bool isDarkMode = watch<ThemeProvider>().isDark;

    return isDarkMode;
  }
}
