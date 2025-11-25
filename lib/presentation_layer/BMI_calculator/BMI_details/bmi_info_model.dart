class BMIInfoDataModel {
  final int bmiColor;
  final String bmiRange;
  final String bmiTitle;

  const BMIInfoDataModel({
    required this.bmiColor,
    required this.bmiRange,
    required this.bmiTitle,
  });
}

List<BMIInfoDataModel> bmiInfo = const <BMIInfoDataModel>[
  BMIInfoDataModel(
    bmiColor: 0xFF03a9f4,
    bmiRange: " < 16.0",
    bmiTitle: "Very severly underweight",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFF29b6f6,
    bmiRange: "16.0 : 16.9",
    bmiTitle: "Severly underweight",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFFADD8E6,
    bmiRange: "17.0 : 18.4",
    bmiTitle: "Underweight",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFF90EE90,
    bmiRange: "18.5 : 24.9",
    bmiTitle: "Normal",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFFFFD700,
    bmiRange: "25.0 : 29.9",
    bmiTitle: "Overweight",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFFFF8C00,
    bmiRange: "30.0 : 34.9",
    bmiTitle: "Obese class I",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFFff6a33,
    bmiRange: "35.0 : 39.9",
    bmiTitle: "Obese class II",
  ),
  BMIInfoDataModel(
    bmiColor: 0xFFFF4500,
    bmiRange: " > 39.9",
    bmiTitle: "Obese class III",
  ),
];
