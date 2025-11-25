import 'package:flutter/material.dart';

class GetBMIHeightProvider with ChangeNotifier {
  bool isCm = true;
  bool isFt = false;

  void get selectCm {
    isCm = true;
    isFt = false;

    notifyListeners();
  }

  void get selectFt {
    isCm = false;
    isFt = true;

    notifyListeners();
  }

  int userHeight = 50;

  void getUserHeight({required int selectedHeight}) {
    userHeight = selectedHeight;
    notifyListeners();
  }
}
