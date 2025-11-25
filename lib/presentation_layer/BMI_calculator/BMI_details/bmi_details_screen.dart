import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/pop_widget.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_details/bmi_info_model.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/calculate_bmi_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_info_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/select_bim_gender.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class BMIDetailsScreen extends StatelessWidget {
  const BMIDetailsScreen({
    super.key,
    required this.age,
    required this.weight,
  });

  final String age;
  final String weight;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, _, __) {
      return Consumer<BMIInfoProvider>(builder: (context, bmiState, _) {
        return Consumer<CalcualteBMIProvider>(
          builder: (context, bmiData, _) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.screenHeight * .05,
                    ),
                    child: const Row(
                      children: <Widget>[
                        PopScreenWidget(),
                        Gap(wRatio: 0.02),
                        Text(
                          "BMI Result",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: FontFamily.mainFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: context.screenWidth * .9,
                            height: context.screenHeight * .27,
                            child: TweenAnimationBuilder(
                              tween: Tween<double>(
                                begin: 0.0,
                                end: bmiData.userBMI,
                              ),
                              duration: const Duration(milliseconds: 1200),
                              builder: (context, bmi, _) {
                                return Stack(
                                  children: <Widget>[
                                    Consumer<SelectBMIGenderProvider>(
                                      builder: (context, gender, _) {
                                        return Positioned(
                                          right: 0,
                                          left: 0,
                                          bottom: 90,
                                          top: 40,
                                          child: SizedBox(
                                            width: context.screenWidth * .3,
                                            height: context.screenHeight * .12,
                                            child: SvgPicture.asset(
                                              gender.isMale
                                                  ? !context.isDark
                                                      ? "assets/images/svg/BMI/man.svg"
                                                      : "assets/images/svg/BMI/man_light.svg"
                                                  : !context.isDark
                                                      ? "assets/images/svg/BMI/woman.svg"
                                                      : "assets/images/svg/BMI/woman_light.svg",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned.fill(
                                      child: SfRadialGauge(
                                        axes: <RadialAxis>[
                                          RadialAxis(
                                            maximum: 50,
                                            minimum: 0,
                                            showLabels: false,
                                            showTicks: false,
                                            axisLineStyle: const AxisLineStyle(
                                              color: Color(0xFFEEF5FF),
                                              thickness: 0.15,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              thicknessUnit:
                                                  GaugeSizeUnit.factor,
                                            ),
                                            pointers: <GaugePointer>[
                                              RangePointer(
                                                value: bmi,
                                                sizeUnit: GaugeSizeUnit.factor,
                                                color: Color(
                                                  bmiInfo[bmiState.bmiIndex]
                                                      .bmiColor,
                                                ),
                                                width: 0.15,
                                                cornerStyle:
                                                    CornerStyle.bothCurve,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 0,
                                      left: 0,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            bmi.toStringAsFixed(2),
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontFamily: FontFamily.mainFont,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            "BMI",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: FontFamily.mainFont,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const Gap(hRatio: 0.01),
                          Consumer<BMIInfoProvider>(
                            builder: (context, bmiState, _) {
                              return SizedBox(
                                width: context.screenWidth * .98,
                                child: Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    children: <InlineSpan>[
                                      const TextSpan(
                                        text: "You have ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontFamily.mainFont,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            bmiInfo[bmiState.bmiIndex].bmiTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontFamily.mainFont,
                                          color: Color(
                                            bmiInfo[bmiState.bmiIndex].bmiColor,
                                          ),
                                          fontSize: 20,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " body weight !",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: FontFamily.mainFont,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Gap(hRatio: 0.01),
                          BMIInfoWidget(
                            age: age,
                            height: bmiData.userHeight.userHeight.toString(),
                            weight: weight,
                          ),
                          const BMIResultWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
    });
  }
}

class BMIInfoWidget extends StatelessWidget {
  const BMIInfoWidget({
    super.key,
    required this.age,
    required this.height,
    required this.weight,
  });

  final String age;
  final String weight;
  final String height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding(10.0),
      margin: padding(10.0),
      decoration: BoxDecoration(
        borderRadius: borderRadius(15.0),
        color: ColorsSwitcher.mainColor,
        boxShadow: mainBoxShadow(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Text(
                "Age",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.mainFont,
                ),
              ),
              Text(
                "$age ",
                style: const TextStyle(
                  fontFamily: FontFamily.mainFont,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.screenHeight * .05,
            child: const VerticalDivider(),
          ),
          Column(
            children: <Widget>[
              const Text(
                "Weight",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.mainFont,
                ),
              ),
              Text(
                "$weight Kg",
                style: const TextStyle(
                  fontFamily: FontFamily.mainFont,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.screenHeight * .05,
            child: const VerticalDivider(),
          ),
          Column(
            children: <Widget>[
              const Text(
                "Height",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.mainFont,
                ),
              ),
              Text(
                "$height Cm",
                style: const TextStyle(
                  fontFamily: FontFamily.mainFont,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BMIResultWidget extends StatelessWidget {
  const BMIResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BMIInfoProvider>(
      builder: (context, bmiState, _) {
        return Container(
          padding: padding(5.0),
          margin: padding(10.0),
          decoration: BoxDecoration(
            color: ColorsSwitcher.mainColor,
            borderRadius: borderRadius(15.0),
            boxShadow: mainBoxShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.generate(
              bmiInfo.length,
              (index) {
                String bmiRange = bmiInfo[index].bmiRange;
                String bmiTitle = bmiInfo[index].bmiTitle;
                int bmiColor = bmiInfo[index].bmiColor;
                return Padding(
                  padding: padding(3.0),
                  child: Container(
                    padding: padding(5.0),
                    decoration: bmiState.bmiIndex == index
                        ? BoxDecoration(
                            color: context.isDark
                                ? const Color(0xFF1A3636)
                                : Colors.white70.withOpacity(0.9),
                            borderRadius: borderRadius(5.0),
                          )
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Color(bmiColor),
                              radius: 13,
                            ),
                            const Gap(wRatio: 0.02),
                            Text(
                              bmiTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.mainFont,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          bmiRange,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.mainFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
