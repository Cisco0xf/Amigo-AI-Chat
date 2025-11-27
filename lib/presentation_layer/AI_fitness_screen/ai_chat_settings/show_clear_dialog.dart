import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/texts.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/amigo_provider.dart';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: borderRadius(10.0)),
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
                        borderRadius: borderRadius(30.0),
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
                        await database.clearChatHistory().whenComplete(() {
                          Navigator.pop(navigatorKey.currentContext!);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadius(30.0),
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
