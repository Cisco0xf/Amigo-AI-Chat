// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/api_constants.dart';
import 'package:amigo/constants/texts.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/data_layer/database/ai_history_database.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/show_error_dialog.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

class ManageAiProvider with ChangeNotifier {
  static List<MessageModel> currentChat = [];

  // Set needed Controllers
  final TextEditingController sendMessageController = TextEditingController();
  final ScrollController aiScrollController = ScrollController();

  final FocusNode aiChatFocus = FocusNode(debugLabel: "AI message request");

  bool get hasData => sendMessageController.text.trim().isNotEmpty;

  // Scroll to bottom in case the animated text is on

  void autoScrollDown() {
    // int resultTextIndex = 0;

    int scrollRatio = 0;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Timer.periodic(
          const Duration(milliseconds: 100),
          (Timer timer) {
            // log("Scrolling Down.....");

            // resultTextIndex++;

            scrollRatio += 100;

            notifyListeners();

            if (aiScrollController.hasClients && scrollRatio < 3000) {
              aiScrollController.animateTo(
                0.0,
                curve: Curves.linear,
                duration: const Duration(milliseconds: 100),
              );
            } else {
              timer.cancel();
            }

            /*    bool isFullTextComplet =
                (lastMessageFromAi.length / 3.5) >= resultTextIndex;

            if (aiScrollController.hasClients && isFullTextComplet) {
              aiScrollController.jumpTo(0.0);
            } else {
              log("Scrolling has been finished ");
              timer.cancel();
            } */
          },
        );
      },
    );
  }

  // Scroll to bottom in case the animated text is off

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (aiScrollController.hasClients) {
          aiScrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  bool isBottomChat = true;

  void get checkBottomChat {
    if (aiScrollController.offset == 0.0) {
      isBottomChat = true;
    } else {
      isBottomChat = false;
    }

    notifyListeners();
  }

  bool isResponseLoading = false;

  // The TextParts from the AI response

  String get lastMessageFromAi {
    List<Content> userHistory = aiChat!.history.toList();

    Content lastContentFromAI = userHistory.last;

    String? lastMessageFromAi =
        lastContentFromAI.parts.whereType<TextPart>().map<String>(
      (part) {
        return part.text;
      },
    ).join("");

    return lastMessageFromAi;
  }

  // Send Message

  // Color sendButtonColor = const Color(0xFF818FB4);

  bool get isUserEnterAnyThing => sendMessageController.text.trim().isNotEmpty;

  final BuildContext context = navigatorKey.currentContext as BuildContext;

  /* ManageChatHistoryProvider get manageChatHistoryDatabase =>
      Provider.of<ManageChatHistoryProvider>(
        context,
        listen: false,
      ); */

  AiSettingsProvider get aiSettings => Provider.of<AiSettingsProvider>(
        context,
        listen: false,
      );

  ChatSession? aiChat;

  GenerativeModel? gemiAI;

  void initializeAIProperties() {
    gemiAI = GenerativeModel(
      model: APIConstants.model,
      apiKey: APIConstants.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: aiSettings.creativityValue,
        maxOutputTokens: aiSettings.outputLengthValue,
      ),
    );

    Log.log("Length of the current chat items => ${currentChat.length}");

    //
    aiChat = gemiAI!.startChat(
      history: <Content>[
        for (int i = 0; i < currentChat.length; i++) ...{
          Content.multi(
            <Part>[
              TextPart(currentChat[i].userMessage),
              if (currentChat[i].userImage != null)
                DataPart("image/jpeg", currentChat[i].userImage!),
            ],
          ),
          Content.model(
            <TextPart>[
              TextPart(currentChat[i].aiResponse),
            ],
          ),
        }
      ],
    );
  }

  Future<void> sendMessageToGemi(BuildContext context) async {
    String message = sendMessageController.text;

    aiChatFocus.unfocus();

    if (!isUserEnterAnyThing) {
      return;
    }

    try {
      isResponseLoading = true;
      notifyListeners();

      Log.log("AI request starts....");
      // final Content contentText = Content.text(message);

      final PickImage multiMedia =
          Provider.of<PickImage>(context, listen: false);

      final Uint8List? userImage = multiMedia.convertedImage;

      final Uint8List? userAudio = multiMedia.loadedAudio;

      final Content userMesssage = Content.multi([
        TextPart(message),
        if (userImage != null) DataPart("image/jpeg", userImage),
        if (userAudio != null) DataPart("audio/mp3", userAudio),
      ]);

      final GenerateContentResponse aiResponse = await aiChat!.sendMessage(
        userMesssage,
      );
      final String? responseText = aiResponse.text;

      if (responseText == null || responseText.isEmpty) {
        isResponseLoading = false;
        notifyListeners();
        return;
      }

      final String? path = multiMedia.audioPath;

      // Add message To Database

      final MessageModel chatMessage = MessageModel(
        userMessage: sendMessageController.text,
        aiResponse: responseText,
        messageTime: DateTime.now(),
        userImage: userImage,
        path: path,
      );

      currentChat = [...currentChat, chatMessage];
      notifyListeners();

      final PickImage picker = Provider.of<PickImage>(
        context,
        listen: false,
      );

      if (picker.convertedImage != null) {
        picker.clearImage();
      }

      if (picker.audioPath != null) {
        picker.clearAudio();
      }

      await ManageChatHistoryDb.addNewMessage(msg: chatMessage).whenComplete(
        () {
          Log.log("Message has been added to database...");
          Log.log("User Message => $message");
          Log.log("AI Response => ${chatMessage.aiResponse}");
        },
      );

      // Scroll to Bottom according to the Animted Text bool value

      if (aiSettings.isResponseAnimated) {
        autoScrollDown();
      } else {
        scrollToBottom();
      }
    } on SocketException {
      await showErrorDialog(error: internetError);
    } catch (error) {
      Log.log("Request Error => $error", color: LColor.red);

      await showErrorDialog(error: errorMsg);
    } finally {
      isResponseLoading = false;
      sendMessageController.clear();
      aiChatFocus.requestFocus();
      notifyListeners();
    }
  }

  Future<void> clearChatHistory() async {
    currentChat = [];
    aiChat = gemiAI!.startChat(history: []);
    notifyListeners();

    await ManageChatHistoryDb.clearDb();
  }

  //  Init current chat to the DB chat

  void initializeCurrentChatFromDBHistory({required List<MessageModel> db}) {
    currentChat = [for (int i = 0; i < db.length; i++) db[i]];
  }
}
