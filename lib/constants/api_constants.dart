import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  static final String geminiApiKey =
      dotenv.env["GEMINI_API_KEY3"] ?? "UNVALID_KEY";

  static const String model = "gemini-2.0-flash";
  //static const String model = "gemini-3-pro-image-preview";
  //static const String model = "gemini-3-pro-image-preview";
  //static const String model = "gemini-2.5-flash-image";
  // static const String model = "gemini-2.5-flash-preview-image";
}
