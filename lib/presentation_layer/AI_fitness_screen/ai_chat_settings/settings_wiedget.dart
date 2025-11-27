import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/assets.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/show_clear_dialog.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AISettingsWidget extends StatelessWidget {
  const AISettingsWidget({super.key});

  List<MessageModel> get _chatHistory => ManageAiProvider.currentChat;

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Consumer<AiSettingsProvider>(
      builder: (context, settings, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: padding(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "AI Settings",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
                const Divider(
                  indent: 70,
                  endIndent: 70,
                ),
                const IsTextAnimatedWidget(),
                const DarkModeWidget(),
                const Divider(),
                ChangeValueWidget(
                  title: "AI Creativity",
                  label: settings.creativitySliderLable.$1,
                  description: settings.creativitySliderLable.$2,
                  min: 0.0,
                  value: (settings.creativityValue / 2) * 100,
                  max: 100,
                  isCreativity: true,
                  onChanged: (double temperature) {
                    settings.changeCreativityVlaue(
                      selectedCreativity: temperature,
                    );
                  },
                  color: 0xFFF6EFBD,
                  imagePath: Assets.creativity,
                ),
                const Gap(hRatio: 0.02),
                ChangeValueWidget(
                  title: "Output length",
                  label: settings.outputLengthSliderLabel.$1,
                  description: settings.outputLengthSliderLabel.$2,
                  min: 100,
                  value: settings.outputLengthValue.toDouble(),
                  max: 8192,
                  onChanged: (double length) {
                    settings.changeOutputLength(
                      selectedLength: length.toInt(),
                    );
                  },
                  color: 0xFFB9E5E8,
                  imagePath: Assets.output,
                ),
                const Gap(hRatio: 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: context.screenWidth * .2,
                      height: context.screenHeight * .06,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showToastification(
                            title: "Settings has been saved successfully",
                            type: ToastificationType.success,
                          );
                        },
                        color: SwitchColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius(25.0),
                        ),
                        child: const Text("Ok"),
                      ),
                    ),
                    const Gap(wRatio: 0.03),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Gap(wRatio: 0.03),
                    SizedBox(
                      width: context.screenWidth * .4,
                      height: context.screenHeight * .06,
                      child: MaterialButton(
                        onPressed: () async {
                          if (_chatHistory.isEmpty) {
                            return;
                          }
                          Navigator.pop(context);
                          await showClearDialog;
                        },
                        color: _chatHistory.isNotEmpty
                            ? const Color(0xFFC62E2E)
                            : const Color(0xFF9e9e9e),
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius(25.0),
                        ),
                        child: const Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Gap(wRatio: 0.02),
                            Text(
                              "Clear Chat",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
}

typedef ChangeAISettings = void Function(double);

class ChangeValueWidget extends StatelessWidget {
  const ChangeValueWidget({
    super.key,
    required this.title,
    required this.label,
    required this.description,
    required this.onChanged,
    required this.min,
    required this.value,
    required this.max,
    required this.color,
    required this.imagePath,
    this.isCreativity = false,
  });

  final String title;
  final ChangeAISettings onChanged;
  final String label;
  final String description;
  final int color;
  final String imagePath;
  final double min;
  final double value;
  final double max;

  final bool isCreativity;

  @override
  Widget build(BuildContext context) {
    return Consumer<AiSettingsProvider>(
      builder: (context, settings, _) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Gap(wRatio: 0.03),
                Container(
                  width: context.screenWidth * .09,
                  height: context.screenHeight * .04,
                  decoration: BoxDecoration(
                    // color: Color(color),
                    borderRadius: borderRadius(5.0),
                  ),
                  child: SvgPicture.asset(imagePath),
                ),
                const Gap(wRatio: 0.02),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
              ],
            ),
            const Gap(hRatio: 0.01),
            Container(
              padding: padding(10.0),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: context.screenHeight * .05,
              decoration: BoxDecoration(
                borderRadius: borderRadius(8.0),
                color: SwitchColors.bgColor,
                border: Border.all(color: SwitchColors.border),
                boxShadow: mainBoxShadow(),
              ),
              child: SliderTheme(
                data: const SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorTextStyle: TextStyle(
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  label:
                      "$label ( ${value.toStringAsFixed(0)} ${isCreativity ? " %" : ""})",
                  max: max,
                  min: min,
                ),
              ),
            ),
            const Gap(hRatio: 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: "$label : ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: FontFamily.mainFont,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF347928),
                      ),
                    ),
                    TextSpan(
                      text: description,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: FontFamily.mainFont,
                        color: SwitchColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class IsTextAnimatedWidget extends StatelessWidget {
  const IsTextAnimatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Animate Response",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.mainFont,
            ),
          ),
          Consumer<AiSettingsProvider>(
            builder: (context, animated, _) {
              return Switch(
                value: animated.isResponseAnimated,
                onChanged: (bool isAnimated) {
                  animated.changeAnimatedText;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DarkModeWidget extends StatelessWidget {
  const DarkModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, mode, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Dark mode",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.mainFont,
              ),
            ),
            Switch(
              value: mode.isDark,
              onChanged: (bool isDark) async => await mode.switchTheme(isDark),
            )
          ],
        ),
      );
    });
  }
}
