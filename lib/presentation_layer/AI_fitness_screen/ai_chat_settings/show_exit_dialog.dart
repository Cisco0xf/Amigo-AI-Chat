import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> get showExitDialog async {
  final BuildContext context = navigatorKey.currentContext!;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius(10.0),
        ),
        child: Padding(
          padding: padding(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                exitQ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.mainFont,
                ),
              ),
              const Gap(hRatio: 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius(20),
                      ),
                    ),
                    child: const Text(
                      "No, stay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: borderRadius(20),
                    ),
                    color: const Color(0xFF6A9C89),
                    child: const Text(
                      "Yes, exit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
