import 'package:flutter/material.dart';

extension AppDimensions on BuildContext {
  double get screenWidth {
    double screenWidth = MediaQuery.of(this).size.width;

    return screenWidth;
  }

  double get screenHeight {
    double screenHeight = MediaQuery.of(this).size.height;

    return screenHeight;
  }
}
