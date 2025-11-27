import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/texts.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/dev_section.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/show_exit_dialog.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_chat_settings/show_settings_dialog.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/chat_widget.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/select_media.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/start_new_chat.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/push_message_widget.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/amigo_provider.dart';
import 'package:flutter/material.dart';
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

    /* manageAi.sendMessageController.addListener(
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
    ); */

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
    context.watch<ThemeProvider>();
    context.watch<ManageAiProvider>();

    return GestureDetector(
      onTap: () {
        MedaiDialogManager.hideSelector();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Builder(
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
                  appTitle,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
                actions: <Widget>[
                  Clicker(
                    onClick: () async {
                      await showDeveloper();
                    },
                    child: const Icon(Icons.developer_mode),
                  ),
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
                  final bool hasHistory =
                      ManageAiProvider.currentChat.isNotEmpty;
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: hasHistory
                            ? const AmigoChat()
                            : const StartNewChatWidget(),
                      ),
                      if (hasHistory)
                        const Positioned(
                          right: 0,
                          left: 0,
                          bottom: 0,
                          child: PushMessageToAIWidget(),
                        ),
                      Positioned(
                        bottom: context.screenHeight * .13,
                        right: 0.0,
                        left: 0.0,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: !chatAI.isBottomChat &&
                                  ManageAiProvider.currentChat.isNotEmpty
                              ? Align(
                                  key: const ValueKey("MJNIS_-NDIkdm948"),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          SwitchColors.accent.withOpacity(0.8),
                                    ),
                                    child: Clicker(
                                      innerPadding: 10.0,
                                      onClick: () => chatAI.scrollToBottom(),
                                      isCircl: true,
                                      child: const Icon(Icons.arrow_downward),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey("MBDIBEI-mfignfr")),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
