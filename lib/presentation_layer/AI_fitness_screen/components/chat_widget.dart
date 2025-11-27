import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/message_widget.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/amigo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AmigoChat extends StatelessWidget {
  const AmigoChat({super.key});

  List<MessageModel> get _chatMessages => ManageAiProvider.currentChat;

  @override
  Widget build(BuildContext context) {
    return Consumer<ManageAiProvider>(
      builder: (context, aiBot, _) {
        // final List<Content> chatHistory = aiBot.aiChat!.history.toList();

        return SingleChildScrollView(
          controller: aiBot.aiScrollController,
          padding: EdgeInsets.only(bottom: context.screenHeight * .13),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              _chatMessages.length * 2,
              (index) {
                return MessageWidget(
                  isFromUser: index % 2 == 0,
                  messageTime: _chatMessages[index ~/ 2].messageTime,
                  //isLastMessage: index == chatHistory.length - 1,
                  isLastMessage: index == (_chatMessages.length * 2) - 1,
                  message: _chatMessages[index ~/ 2],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/* 
class AmigoChat extends StatelessWidget {
  const AmigoChat({super.key});

  List<MessageModel> get _chatMessages => ManageAiProvider.currentChat;

  @override
  Widget build(BuildContext context) {
    return Consumer<ManageAiProvider>(
      builder: (context, aiBot, _) {
        final List<Content> chatHistory = aiBot.aiChat!.history.toList();

        return SingleChildScrollView(
          controller: aiBot.aiScrollController,
          padding: EdgeInsets.only(bottom: context.screenHeight * .13),
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              _chatMessages.length * 2 /* chatHistory.length */,
              (index) {
                //final Content content = chatHistory[index];
                /* final String chatTexts = content.parts
                    .whereType<TextPart>()
                    .map<String>((partText) => partText.text)
                    .join("");- */
                return MessageWidget(
                  isFromUser:
                      index == 0 || index % 2 == 0 /* content.role == "user" */,
                  messageTime: _chatMessages[index ~/ 2].messageTime,
                  //isLastMessage: index == _chatMessages.length - 1,
                  isLastMessage: index == chatHistory.length - 1,
                  message: _chatMessages[index ~/ 2],
                  // message: chatTexts,
                  // content: content,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
 */