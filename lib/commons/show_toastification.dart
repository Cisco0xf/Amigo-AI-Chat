import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToastification({
  required String title,
  ToastificationType type = ToastificationType.info,
}) {
  final BuildContext context = navigatorKey.currentContext!;
  toastification.show(
    context: context,
    showProgressBar: false,
    autoCloseDuration: const Duration(milliseconds: 2000),
    animationDuration: const Duration(milliseconds: 300),
    type: type,
    backgroundColor: SwitchColors.opcColor,
    applyBlurEffect: true,
    description: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: FontFamily.mainFont,
      ),
    ),
  );
}
