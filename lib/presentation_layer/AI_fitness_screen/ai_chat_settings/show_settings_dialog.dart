import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/settings_wiedget.dart';
import 'package:flutter/material.dart';

Future<void> get showSettingsDialog async {
  final BuildContext context = navigatorKey.currentContext!;
  await showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.6, end: 1.0).animate(animation),
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(10.0),
            ),
            child: const AISettingsWidget(),
          ),
        ),
      );
    },
  );
}
