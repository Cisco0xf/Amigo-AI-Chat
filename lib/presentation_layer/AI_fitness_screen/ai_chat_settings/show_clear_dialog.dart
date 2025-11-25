import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/text_styles.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_fitness_main_screen.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> get showClearDialog async {
  final BuildContext context = navigatorKey.currentContext!;
  await showDialog(
    context: context,
    builder: (context) {
      return const ShowClearDialog();
    },
  );
}

class ShowClearDialog extends StatelessWidget {
  const ShowClearDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Padding(
        padding: padding(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              clearSession,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.mainFont,
              ),
            ),
            const Gap(hRatio: 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  width: context.screenWidth * .3,
                  height: context.screenHeight * .07,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius(25),
                      ),
                    ),
                    child: const Text("No"),
                  ),
                ),
                Consumer<ManageAiProvider>(builder: (context, database, _) {
                  return SizedBox(
                    width: context.screenWidth * .3,
                    height: context.screenHeight * .07,
                    child: MaterialButton(
                      onPressed: () async {
                        /* Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return const AiFitnessMainScreen();
                              },
                            ),
                          ); */
                        await database.clearChatHistory().whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius(25),
                      ),
                      color: const Color(0xFFC62E2E),
                      child: const Text("Delete"),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
