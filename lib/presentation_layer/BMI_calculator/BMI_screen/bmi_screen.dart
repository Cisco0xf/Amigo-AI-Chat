import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/components/bmi_title_widget.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/components/select_gender_widget.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/components/select_height_widget.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/components/weight_age_widget.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/calculate_bmi_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_info_provider.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BMIMainScreen extends StatefulWidget {
  const BMIMainScreen({super.key});

  @override
  State<BMIMainScreen> createState() => _BMIMainScreenState();
}

class _BMIMainScreenState extends State<BMIMainScreen> {
  late final TextEditingController weightController;
  late final TextEditingController ageController;

  @override
  void initState() {
    weightController = TextEditingController();
    ageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    weightController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(
          FocusNode(),
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                children: <Widget>[
                  const BMITitleWidget(),
                  const SelectGenderWidget(),
                  const SelectBMIHeightWidget(),
                  GetWeightAgeDataWidget(
                    weightController: weightController,
                    ageController: ageController,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 125,
              left: 125,
              child: CalculateBMICustomButtonWidget(
                weightController: weightController,
                ageController: ageController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculateBMICustomButtonWidget extends StatelessWidget {
  const CalculateBMICustomButtonWidget({
    super.key,
    required this.weightController,
    required this.ageController,
  });
  final TextEditingController weightController;
  final TextEditingController ageController;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, _, __) {
      return Consumer<BMIInfoProvider>(
        builder: (context, getBMIInfo, _) {
          return Consumer<CalcualteBMIProvider>(
            builder: (context, calculateBMI, _) {
              return Container(
                height: context.screenHeight * .21,
                decoration: BoxDecoration(
                  borderRadius: borderRadius(55, side: Side.top),
                  boxShadow: !context.isDark
                      ? const <BoxShadow>[
                          BoxShadow(
                            blurRadius: 5.0,
                            spreadRadius: 0.1,
                            color: Color(0xFFe0e0e0),
                            blurStyle: BlurStyle.normal,
                            offset: Offset(4, 4),
                          ),
                        ]
                      : null,
                  color: ColorsSwitcher.mainColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: borderRadius(55, side: Side.top),
                    onTap: () {
                      calculateBMI.calculteBMI(
                        weightController: weightController,
                        ageController: ageController,
                      );
                      getBMIInfo.getBMIState;
                    },
                    child: Padding(
                      padding: padding(20.0),
                      child: const Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 28,
                            child: Icon(Icons.arrow_forward),
                          ),
                          Gap(hRatio: 0.01),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Calculate",
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: FontFamily.mainFont,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }
}
