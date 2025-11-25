import 'package:flutter/material.dart';

class SelectBMIGenderProvider with ChangeNotifier {
  bool isMale = true;
  bool isFemale = false;

  void get selectMale {
    isMale = true;
    isFemale = false;
    notifyListeners();
  }

  void get selectFemale {
    isMale = false;
    isFemale = true;
    notifyListeners();
  }
}
