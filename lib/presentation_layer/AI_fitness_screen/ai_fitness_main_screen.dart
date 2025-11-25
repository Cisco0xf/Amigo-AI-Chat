import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/show_exit_dialog.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/show_settings_dialog.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/chat_widget.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/start_new_chat.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/push_message_widget.dart';
import 'package:amigo/presentation_layer/BMI_calculator/BMI_screen/bmi_screen.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AiFitnessMainScreen extends StatefulWidget {
  const AiFitnessMainScreen({super.key});

  @override
  State<AiFitnessMainScreen> createState() => _AiFitnessMainScreenState();
}

class _AiFitnessMainScreenState extends State<AiFitnessMainScreen> {
  late final ManageAiProvider manageAi;
  Color buttonColor = const Color(0xFF818FB4);

  @override
  void initState() {
    manageAi = Provider.of<ManageAiProvider>(
      context,
      listen: false,
    );

    manageAi.initializeAIProperties();

    manageAi.sendMessageController.addListener(
      () {
        setState(
          () {
            if (manageAi.isUserEnterAnyThing) {
              buttonColor = const Color(0xFF08C2FF);
            } else {
              buttonColor = const Color(0xFF818FB4);
            }
          },
        );
      },
    );

    manageAi.aiScrollController.addListener(
      () {
        if (manageAi.aiScrollController.hasClients) {
          manageAi.checkBottomChat;
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context, _, __) {
        return Builder(
          builder: (context) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) async {
                if (!didPop) {
                  await showExitDialog;
                  return;
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: !context.isDark
                      ? const Color(0xFFEDE8DC)
                      : const Color(0xFF40534C),
                  title: const Text(
                    "AI Fitness",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontFamily.mainFont,
                    ),
                  ),
                  actions: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.0),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const BMIMainScreen();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: padding(10.0),
                          child: SizedBox.square(
                            dimension: context.screenWidth * .1,
                            child: SvgPicture.asset(
                              "assets/images/svg/fitness_items/BMI.svg",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(wRatio: 0.02),
                    IconButton(
                      onPressed: () async {
                        await showSettingsDialog;
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                body: Consumer<ManageAiProvider>(
                  builder: (context, chatAI, __) {
                    //bool isChatEmpty = aiChatHistory.isEmpty;
                    bool isHistoryEmpty =
                        chatAI.aiChat!.history.toList().isEmpty;
                    return Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: /*  isChatEmpty && */ isHistoryEmpty
                              ? const StartNewChatWidget()
                              : const FitnessChatWidget(),
                        ),
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: PushMessageToAIWidget(
                            buttonColor: buttonColor,
                          ),
                        ),
                        Positioned(
                          bottom: context.screenHeight * .11,
                          right: 0,
                          left: 0,
                          child: Builder(
                            builder: (context) {
                              return Visibility(
                                visible: !chatAI.isBottomChat &&
                                    ManageAiProvider.currentChat.isNotEmpty,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      chatAI.scrollToBottom;
                                    },
                                    customBorder: const CircleBorder(),
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xFF789DBC)
                                          .withOpacity(0.6),
                                      child: const Icon(Icons.arrow_downward),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
