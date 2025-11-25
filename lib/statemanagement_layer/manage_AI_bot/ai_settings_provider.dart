import 'dart:developer';

import 'package:amigo/data_layer/save_last_data/save_last_data.dart';
import 'package:flutter/material.dart';

class AiSettingsProvider with ChangeNotifier {
  // Save user Changes

  final SaveUserChanges saveUserCreativity = SaveUserCreativity();
  final SaveUserChanges saveUserOutputLength = SaveUserOutputLength();
  final SaveUserChanges saveIsTextAnimtedValue = SaveAnimatedTextBoolValue();

  //  Change the creativity value
  double creativityValue = 1.5;

  void changeCreativityVlaue({
    required double selectedCreativity,
  }) {
    double truthCreativity = (selectedCreativity / 100) * 2;

    creativityValue = truthCreativity;

    saveUserCreativity.putDataInDatabase(data: truthCreativity);

    log("Creativity Value : $creativityValue");

    notifyListeners();
  }

  // Change the output length value

  int outputLengthValue = 4056;

  void changeOutputLength({
    required int selectedLength,
  }) {
    outputLengthValue = selectedLength;

    saveUserOutputLength.putDataInDatabase(data: selectedLength);

    log("Output Length : $outputLengthValue");

    notifyListeners();
  }

  // Set the is Text Animated value

  bool isResponseAnimated = true;

  void get changeAnimatedText {
    isResponseAnimated = !isResponseAnimated;

    saveIsTextAnimtedValue.putDataInDatabase(data: isResponseAnimated);

    log("Is Response Text Animated $isResponseAnimated");

    notifyListeners();
  }

  // Intialize Settings values

  Future<void> get initalizeSettingsData async {
    double creativityFromDatabase =
        await saveUserCreativity.getDataFromDatabase;

    int outputLengthFromDatabase =
        await saveUserOutputLength.getDataFromDatabase;

    bool isTextanimtedFromDatabase =
        await saveIsTextAnimtedValue.getDataFromDatabase;

    creativityValue = creativityFromDatabase;
    outputLengthValue = outputLengthFromDatabase;
    isResponseAnimated = isTextanimtedFromDatabase;

    notifyListeners();
  }

  //// Show labels of the Slider in Settings Widget

  // Creativity label and description

  (String, String) get creativitySliderLable {
    String lable;
    String description;
    if (creativityValue >= 0.0 && creativityValue <= 0.9) {
      lable = "Focused";
      description =
          "For low values, indicating more deterministic, straightforward responses.";
    } else if (creativityValue > 0.9 && creativityValue <= 1.4) {
      lable = "Balanced";
      description =
          "For mid-range values, giving a blend of reliability and creativity.";
    } else if (creativityValue > 1.4 && creativityValue <= 2.0) {
      lable = "Creative";
      description =
          "For high values, leading to more varied, creative responses.";
    } else {
      lable = "";
      description = "";
    }

    return (lable, description);
  }

  // Output Length Label

  (String, String) get outputLengthSliderLabel {
    String label;
    String description;

    if (outputLengthValue >= 100 && outputLengthValue <= 1000) {
      label = "Short";
      description = "Quick, concise answers for simple queries.";
    } else if (outputLengthValue > 1000 && outputLengthValue <= 3000) {
      label = "Medium";
      description = "Detailed responses that cover the main points.";
    } else if (outputLengthValue > 1000 && outputLengthValue <= 6000) {
      label = "Long";
      description = "In-depth answers for complex topics with examples.";
    } else if (outputLengthValue > 6000 && outputLengthValue <= 8192) {
      label = "Very Long";
      description = "Extensive responses with detailed explanations.";
    } else {
      label = "";
      description = "";
    }

    return (label, description);
  }
}
