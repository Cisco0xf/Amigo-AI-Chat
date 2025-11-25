import 'dart:developer';

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/components/ruler_component.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_height_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SelectBMIHeightWidget extends StatefulWidget {
  const SelectBMIHeightWidget({super.key});

  @override
  State<SelectBMIHeightWidget> createState() => _SelectBMIHeightWidgetState();
}

class _SelectBMIHeightWidgetState extends State<SelectBMIHeightWidget> {
  int selectedIndex = 50;
  @override
  Widget build(BuildContext context) {
    return Consumer<GetBMIHeightProvider>(
      builder: (context, height, _) {
        return Container(
          padding: const EdgeInsets.only(
            top: 10.0,
            right: 10,
            left: 10,
          ),
          margin: padding(10.0),
          height: context.screenHeight * .2,
          decoration: BoxDecoration(
            color: ColorsSwitcher.mainColor,
            borderRadius: borderRadius(15.0),
            boxShadow: mainBoxShadow(),
          ),
          child: Stack(
            children: <Widget>[
              const RulerWidget(),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: context.screenWidth * .2,
                          height: context.screenHeight * .06,
                          child: SvgPicture.asset(
                            "assets/images/svg/BMI/ruler.svg",
                          ),
                        ),
                        const Gap(hRatio: 0.02),
                        const Text(
                          "Height",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.mainFont,
                          ),
                        ),
                        /*   const HeightUniteWidget(), */
                      ],
                    ),
                    const Gap(wRatio: 0.02),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          //color: Colors.blue,
                          width: context.screenWidth * .2,
                          height: context.screenHeight * .13,
                          child: ListWheelScrollView(
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: context.screenHeight * .045,
                            perspective: 0.005,
                            onSelectedItemChanged: (currentIndex) {
                              setState(
                                () {
                                  selectedIndex = currentIndex + 50;
                                },
                              );

                              height.getUserHeight(
                                selectedHeight: currentIndex + 50,
                              );

                              log("Current Index before : $currentIndex");
                              log("Current Index after : ${currentIndex + 50}");
                            },
                            children: <Widget>[
                              for (int i = 50; i <= 250; i++) ...{
                                Container(
                                  decoration: BoxDecoration(
                                    color: selectedIndex == i
                                        ? const Color(0xFFFBF9F1)
                                        : null,
                                    borderRadius: borderRadius(10.0),
                                    border: Border.all(
                                      color: selectedIndex == i
                                          ? Colors.black
                                          : const Color(0x00000000),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: selectedIndex == i ? 1.0 : 0.5,
                                    child: Text(
                                      "$i",
                                      style: TextStyle(
                                        fontSize: selectedIndex == i ? 17 : 15,
                                        color: selectedIndex == i
                                            ? Colors.red
                                            : null,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              },
                            ],
                          ),
                        ),
                        const Gap(wRatio: 0.03),
                        SizedBox(
                          width: context.screenWidth * .12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                height.isCm ? "CM" : "FT",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: FontFamily.mainFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HeightUniteWidget extends StatelessWidget {
  const HeightUniteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GetBMIHeightProvider>(
      builder: (context, height, _) {
        return Container(
          margin: padding(10.0),
          decoration: BoxDecoration(
            borderRadius: borderRadius(5.0),
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Opacity(
                opacity: height.isCm ? 1.0 : 0.3,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    height.selectCm;
                  },
                  child: const Text(
                    "CM",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.mainFont,
                    ),
                  ),
                ),
              ),
              const Gap(wRatio: 0.05),
              Opacity(
                opacity: height.isFt ? 1.0 : 0.3,
                child: InkWell(
                  onTap: () {
                    height.selectFt;
                  },
                  customBorder: const CircleBorder(),
                  child: const Text(
                    "FT",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.mainFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
