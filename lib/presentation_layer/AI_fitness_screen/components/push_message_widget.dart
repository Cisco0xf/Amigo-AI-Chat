import 'dart:ui';

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/full_image_dialog.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/select_media.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/wavy_audio.dart';
import 'package:amigo/statemanagement_layer/catch_text_local/catch_text_locale.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:auto_lang_field/auto_lang_field.dart';
import 'package:auto_lang_field/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class PushMessageToAIWidget extends StatelessWidget {
  const PushMessageToAIWidget({super.key, this.init = false});

  final bool init;

  @override
  Widget build(BuildContext context) {
    context.watch<ManageAiProvider>();
    return Column(
      children: [
        Consumer<PickMediaProvider>(
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
                            child: Clicker(
                              onClick: () async {
                                await showFullImageDialog(
                                    picker.convertedImage!);
                              },
                              child: Image.memory(
                                picker.convertedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                          bgColor: SwitchColors.secondary,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Consumer<DetectLanguage>(
                    builder: (context, textLocale, _) {
                      final bool isEn = textLocale.current == LanguageCode.en;
                      return Expanded(
                        child: ClipRRect(
                          borderRadius: borderRadius(10),
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: SizedBox(
                                height: init ? 100 : null,
                                child: AutoLangField(
                                  expands: true,
                                  keyboardType: TextInputType.multiline,
                                  controller: ai.sendMessageController,
                                  focusNode: ai.aiChatFocus,
                                  autofocus: true,
                                  enabled: !ai.isResponseLoading,
                                  maxLines: null,
                                  autocorrect: true,
                                  scrollPadding: const EdgeInsets.all(5.0),
                                  onChanged: (String text) {
                                    //  textLocale.catchTextLocal(text: text);
                                  },
                                  onLanguageDetected: (value, detectedLang) {
                                    context
                                        .read<DetectLanguage>()
                                        .catchInputLangCode(
                                            detectedLang!.langCode);
                                  },
                                  supportedLanguages: const [
                                    LanguageCode.ar,
                                    LanguageCode.en,
                                  ],
                                  textPropertiesPerLanguage: const {
                                    LanguageCode.ar: TextProperties(
                                      style: TextStyle(
                                        fontFamily: FontFamily.arabicFont,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    LanguageCode.en: TextProperties(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  },

                                  /* style: TextStyle(
                                    fontFamily: textLocale.isEnglish
                                        ? null
                                        : FontFamily.arabicFont,
                                    fontWeight: textLocale.isEnglish
                                        ? FontWeight.bold
                                        : null,
                                  ), */
                                  textDirection: isEn
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      maxHeight: context.screenHeight * .11,
                                    ),
                                    filled: true,
                                    fillColor:
                                        SwitchColors.accent.withOpacity(0.6),
                                    hintText: "Enter a fitness question...",
                                    hintStyle: const TextStyle(
                                      fontFamily: FontFamily.mainFont,
                                    ),
                                    prefixIcon: const SelectMedia(),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: borderRadius(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: borderRadius(10.0),
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: borderRadius(10.0),
                                      borderSide: BorderSide(
                                        color: SwitchColors.border,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Gap(wRatio: 0.03),
                  CircleAvatar(
                    backgroundColor: SwitchColors.accent,
                    radius: 27,
                    child: !(ai.isResponseLoading)
                        ? IconButton(
                            onPressed: () async {
                              await ai.sendMessageToGemi(context);
                            },
                            icon: Icon(Icons.send,
                                color: ai.hasData ? SwitchColors.text : null),
                          )
                        : LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.white, size: 28.0),
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
