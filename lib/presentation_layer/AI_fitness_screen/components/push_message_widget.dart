import 'dart:async';

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/wavy_audio.dart';
import 'package:amigo/statemanagement_layer/catch_text_local/catch_text_locale.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class PushMessageToAIWidget extends StatelessWidget {
  const PushMessageToAIWidget({
    super.key,
    required this.buttonColor,
  });

  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<PickImage>(
          builder: (context, picker, _) {
            return Row(
              children: <Widget>[
                if (picker.convertedImage != null) ...{
                  Container(
                    color: Colors.transparent,
                    padding: padding(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CancelButton(onTap: () => picker.clearImage()),
                        const Gap(height: 5.0),
                        SizedBox.square(
                          dimension: context.screenHeight * .15,
                          child: ClipRRect(
                            borderRadius: borderRadius(10.0),
                            child: Image.memory(picker.convertedImage!),
                          ),
                        ),
                      ],
                    ),
                  ),
                },
                if (picker.audioPath != null) ...{
                  const Gap(width: 10.0),
                  if (picker.loadingAudio)
                    LoadingAnimationWidget.bouncingBall(
                        color: Colors.white, size: 30)
                  else ...{
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CancelButton(
                          onTap: () async => await picker.clearAudio(),
                        ),
                        const Gap(height: 10.0),
                        WavyAudio(
                          path: picker.audioPath!,
                          width: context.screenWidth * .6,
                        ),
                      ],
                    )
                  }
                }
              ],
            );
          },
        ),
        Consumer<ManageAiProvider>(
          builder: (__, ai, _) {
            return Padding(
              padding: padding(10),
              child: Row(
                children: <Widget>[
                  Consumer<CatchTextLocalProvider>(
                    builder: (context, textLocale, _) {
                      return Expanded(
                        child: TextField(
                          controller: ai.sendMessageController,
                          focusNode: ai.aiChatFocus,
                          autofocus: true,
                          enabled: !ai.isResponseLoading,
                          onChanged: (String text) {
                            textLocale.catchTextLocal(text: text);
                          },
                          style: TextStyle(
                            fontFamily: textLocale.isEnglish
                                ? null
                                : FontFamily.arabicFont,
                            fontWeight:
                                textLocale.isEnglish ? FontWeight.bold : null,
                          ),
                          textDirection: textLocale.isEnglish
                              ? TextDirection.ltr
                              : TextDirection.rtl,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: !context.isDark
                                ? const Color(0xFF6eadf9).withOpacity(0.9)
                                : const Color(0xFF03346E).withOpacity(0.9),
                            hintText: "Enter a fitness question...",
                            hintStyle: const TextStyle(
                              fontFamily: FontFamily.mainFont,
                            ),
                            prefixIcon: IconButton(
                              onPressed: () async {
                                /*  await context
                                    .read<PickImage>()
                                    .catchImageFromStorage(); */
                                await context
                                    .read<PickImage>()
                                    .loadAudioFronStorage();
                              },
                              icon: const Icon(Icons.link_rounded),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: borderRadius(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue.shade300,
                                width: 1.0,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: borderRadius(30.0),
                              borderSide: BorderSide(
                                color: Colors.blue.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: borderRadius(30.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF176B87),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Gap(wRatio: 0.03),
                  CircleAvatar(
                    backgroundColor: !context.isDark
                        ? const Color(0xFFA2D2DF)
                        : const Color(0xFF6eadf9),
                    radius: 27,
                    child: !(ai.isResponseLoading)
                        ? IconButton(
                            onPressed: () async {
                              await ai.sendMessageToGemi(context);
                            },
                            icon: Icon(Icons.send, color: buttonColor),
                          )
                        : LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.white,
                            size: 28.0,
                          ) /* SizedBox(
                            width: context.screenWidth * .2,
                            height: context.screenHeight * .07,
                            child: Lottie.asset(
                              "assets/animations/loading_1.json",
                            ),
                          ) */
                    ,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 30.0,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black38,
          border: Border.all(color: Colors.white12),
        ),
        child: Clicker(
          innerPadding: 0.0,
          isCircl: true,
          onClick: onTap,
          child: const Icon(Icons.close, color: Colors.red),
        ),
      ),
    );
  }
}
