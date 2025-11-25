import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/pop_widget.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class BMITitleWidget extends StatelessWidget {
  const BMITitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 12.0,
        left: 12.0,
        top: context.screenHeight * .05,
      ),
      child: const Row(
        children: <Widget>[
          PopScreenWidget(),
          Text(
            "BMI calculator",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.mainFont,
            ),
          ),
        ],
      ),
    );
  }
}
