import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SaveUserChanges {
  Future<void> putDataInDatabase({
    required dynamic data,
  });
  Future<dynamic> get getDataFromDatabase;
}

class SaveUserCreativity implements SaveUserChanges {
  final String _creativityKey = "CREATIVITY_KEY";

  @override
  Future<void> putDataInDatabase({required dynamic data}) async {
    final SharedPreferences creativityPref =
        await SharedPreferences.getInstance();

    await creativityPref.setDouble(_creativityKey, data);
  }

  @override
  Future<dynamic> get getDataFromDatabase async {
    final SharedPreferences creativityPref =
        await SharedPreferences.getInstance();

    double savedCreativity = creativityPref.getDouble(_creativityKey) ?? 1.5;

    return savedCreativity;
  }
}

class SaveUserOutputLength implements SaveUserChanges {
  final String _outputLengthyKey = "OUTPUTLENGTH_KEY";

  @override
  Future<void> putDataInDatabase({required dynamic data}) async {
    final SharedPreferences outputLengthyPref =
        await SharedPreferences.getInstance();

    await outputLengthyPref.setInt(_outputLengthyKey, data);
  }

  @override
  Future<dynamic> get getDataFromDatabase async {
    final SharedPreferences outputLengthyPref =
        await SharedPreferences.getInstance();

    int savedOutputLengthy =
        outputLengthyPref.getInt(_outputLengthyKey) ?? 4056;

    return savedOutputLengthy;
  }
}

class SaveAnimatedTextBoolValue implements SaveUserChanges {
  final String _animatedTExtValue = "IS_TEXT_ANIMTED_KEY";

  @override
  Future<void> putDataInDatabase({required dynamic data}) async {
    final SharedPreferences isTextAnimtedPref =
        await SharedPreferences.getInstance();

    await isTextAnimtedPref.setBool(_animatedTExtValue, data);
  }

  @override
  Future<dynamic> get getDataFromDatabase async {
    final SharedPreferences animatedTExtPref =
        await SharedPreferences.getInstance();

    bool isTextAnimated = animatedTExtPref.getBool(_animatedTExtValue) ?? true;

    return isTextAnimated;
  }
}
