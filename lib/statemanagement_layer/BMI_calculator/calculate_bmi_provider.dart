import 'dart:developer';

import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_details/bmi_details_screen.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_height_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CalcualteBMIProvider with ChangeNotifier {
  final BuildContext context = navigatorKey.currentContext!;

  GetBMIHeightProvider get userHeight => Provider.of<GetBMIHeightProvider>(
        context,
        listen: false,
      );

  double userBMI = 0.0;

  void calculteBMI({
    required TextEditingController weightController,
    required TextEditingController ageController,
  }) {
    if (ageController.text.isEmpty || weightController.text.isEmpty) {
      showToastification(
        title: "Please insert valid value",
      );
      return;
    }
    if (weightController.text.contains("..") ||
        weightController.text.contains("-") ||
        weightController.text.contains(",") ||
        weightController.text.contains(" ")) {
      showToastification(
        title: "Please insert valid value",
        type: ToastificationType.error,
      );
      return;
    }
    if (ageController.text.contains(".") ||
        ageController.text.contains("-") ||
        ageController.text.contains(",") ||
        ageController.text.contains(" ")) {
      showToastification(
        title: "Please insert valid value",
        type: ToastificationType.error,
      );
      return;
    }

    double userWeight = double.parse(weightController.text);
    int userAge = int.parse(ageController.text);
    int height = userHeight.userHeight;

    if (userWeight == 0 || userWeight > 250) {
      showToastification(
        title: "Please insert valide wight",
        type: ToastificationType.error,
      );
      return;
    }

    if (userAge == 0 || userAge >= 130) {
      showToastification(
        title: "Please insert valide age",
        type: ToastificationType.error,
      );
      return;
    }

    double heightM = height / 100;

    double calcultedBMI = userWeight / (heightM * heightM);
    String bmiRounded = calcultedBMI.toStringAsFixed(2);
    userBMI = double.parse(bmiRounded);

    if (userBMI <= 12) {
      showToastification(
        title: "BMI value is too low, please check the inserted values",
        type: ToastificationType.error,
      );
      return;
    }

    if (userBMI >= 60) {
      showToastification(
        title: "BMI value is too high, please check the inserted values",
        type: ToastificationType.error,
      );
      return;
    }

    Navigator.of(navigatorKey.currentContext!).push(
      MaterialPageRoute(
        builder: (context) {
          return BMIDetailsScreen(
            age: ageController.text,
            weight: weightController.text,
          );
        },
      ),
    );

    log("User BMI : $userBMI");
    notifyListeners();
  }
}
