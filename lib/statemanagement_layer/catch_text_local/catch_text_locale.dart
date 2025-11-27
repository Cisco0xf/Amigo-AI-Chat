import 'package:auto_lang_field/constants/enums.dart';
import 'package:flutter/material.dart';
/* 
final RegExp english = RegExp(r'^[a-zA-Z]+');
final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');

class CatchTextLocalProvider with ChangeNotifier {
  bool isEnglish = true;

  void catchTextLocal({required String text}) {
    if (english.hasMatch(text)) {
      isEnglish = true;
    } else if (arabic.hasMatch(text)) {
      isEnglish = false;
    }

    notifyListeners();
  }
} */
/* 
extension TextLocale on String {
  bool get isArabicText {
    if (arabic.hasMatch(this)) {
      return true;
    } else {
      return false;
    }
  }
}
 */
class DetectLanguage extends ChangeNotifier {
  
  LanguageCode current = LanguageCode.en;

  void catchInputLangCode(LanguageCode code) {
    current = code;
    notifyListeners();
  }

}
