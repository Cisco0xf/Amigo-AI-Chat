import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required String error,
}) async {
  final BuildContext context = navigatorKey.currentContext!;
  await showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return const SizedBox();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(5.0),
            ),
            child: Padding(
              padding: padding(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    error,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: FontFamily.mainFont,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: const Color(0xFF3e4e80),
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius(15.0),
                        ),
                        child: const Text(
                          "Got it",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
