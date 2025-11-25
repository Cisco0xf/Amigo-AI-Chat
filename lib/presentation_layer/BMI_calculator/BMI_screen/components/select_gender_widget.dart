import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/select_bim_gender.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectGenderWidget extends StatelessWidget {
  const SelectGenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectBMIGenderProvider>(
      builder: (context, gender, _) {
        return Container(
          width: context.screenWidth * .95,
          height: context.screenHeight * .08,
          margin: padding(10.0),
          decoration: BoxDecoration(
            borderRadius: borderRadius(30.0),
            color: ColorsSwitcher.mainColor,
            boxShadow: mainBoxShadow(
              spreadRadius: 0.09,
              blurRadius: 6.0,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: GenderItemWidget(
                  onTap: () {
                    gender.selectMale;
                  },
                  icon: Icons.male,
                  gender: "Male",
                  isSelected: gender.isMale,
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: GenderItemWidget(
                  onTap: () {
                    gender.selectFemale;
                  },
                  icon: Icons.female,
                  gender: "Female",
                  isSelected: gender.isFemale,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GenderItemWidget extends StatelessWidget {
  const GenderItemWidget({
    super.key,
    required this.icon,
    required this.onTap,
    required this.gender,
    required this.isSelected,
  });
  final String gender;
  final bool isSelected;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: context.screenWidth * .43,
      decoration: BoxDecoration(
        borderRadius: borderRadius(30.0),
        color: isSelected
            ? context.isDark
                ? const Color(0xFF1A3636)
                : const Color(0xFFFFFFFF)
            : ColorsSwitcher.mainColor,
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius(30.0),
          onTap: onTap,
          child: Padding(
            padding: padding(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: isSelected ? Colors.red : null,
                ),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: isSelected ? FontFamily.mainFont : null,
                    color: isSelected ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
