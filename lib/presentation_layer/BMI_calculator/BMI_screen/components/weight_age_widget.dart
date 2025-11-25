import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/calculate_bmi_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GetWeightAgeDataWidget extends StatelessWidget {
  const GetWeightAgeDataWidget({
    super.key,
    required this.ageController,
    required this.weightController,
  });

  final TextEditingController weightController;
  final TextEditingController ageController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalcualteBMIProvider>(
      builder: (context, bmi, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            WeightAgeWidget(
              controller: weightController,
              hintText: "Enter Weight",
              imagePath: "assets/images/svg/BMI/weight.svg",
              title: "Weight(kg)",
            ),
            WeightAgeWidget(
              controller: ageController,
              hintText: "Enter Age",
              imagePath: "assets/images/svg/BMI/age.svg",
              title: "Age",
              isAge: true,
            ),
          ],
        );
      },
    );
  }
}

class WeightAgeWidget extends StatelessWidget {
  const WeightAgeWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.imagePath,
    required this.title,
    this.isAge = false,
  });

  final String imagePath;
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool isAge;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: context.screenWidth * .1,
                height: context.screenHeight * .04,
                child: SvgPicture.asset(imagePath),
              ),
              if (isAge) const Gap(wRatio: 0.02),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.mainFont,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.screenHeight * .09,
            width: context.screenWidth * .35,
            child: TextFormField(
              controller: controller,
              /* showCursor: true,
                  readOnly: true, */
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(3),
              ],
              keyboardType: TextInputType.number,
              cursorHeight: 27,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.mainFont,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  fontFamily: FontFamily.mainFont,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
