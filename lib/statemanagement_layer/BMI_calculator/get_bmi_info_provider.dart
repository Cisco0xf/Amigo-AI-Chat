import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/calculate_bmi_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BMIInfoProvider with ChangeNotifier {
  final BuildContext context = navigatorKey.currentContext!;
  CalcualteBMIProvider get bmi => Provider.of<CalcualteBMIProvider>(
        context,
        listen: false,
      );
  int bmiIndex = 0;
  void get getBMIState {
    double bmiValue = bmi.userBMI;

    if (bmiValue < 16.0) {
      bmiIndex = 0;
    } else if (bmiValue > 16.0 && bmiValue <= 16.9) {
      bmiIndex = 1;
    } else if (bmiValue > 17.0 && bmiValue <= 18.4) {
      bmiIndex = 2;
    } else if (bmiValue > 18.0 && bmiValue <= 24.9) {
      bmiIndex = 3;
    } else if (bmiValue > 25.0 && bmiValue <= 29.9) {
      bmiIndex = 4;
    } else if (bmiValue > 30.0 && bmiValue <= 34.9) {
      bmiIndex = 5;
    } else if (bmiValue > 35.0 && bmiValue <= 39.9) {
      bmiIndex = 6;
    } else if (bmiValue > 39.9) {
      bmiIndex = 7;
    } else {
      bmiIndex = 3;
    }
    notifyListeners();
  }
}
