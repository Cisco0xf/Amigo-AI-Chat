import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/format_message_time.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/text_styles.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/wavy_audio.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    required this.isFromUser,
    /*  required this.message, */
    required this.content,
    required this.isLastMessage,
    required this.messageTime,
    required this.message,
  });

  /*  final String message; */
  final Content content;
  final DateTime messageTime;
  final bool isFromUser;
  final bool isLastMessage;
  final MessageModel message;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isResponseEnded = true;

  /* String get message {
    return widget.content.parts
        .whereType<TextPart>()
        .map<String>((partText) => partText.text)
        .join("");
  } */

  String get message => widget.isFromUser
      ? widget.message.userMessage
      : widget.message.aiResponse;

  Widget _mulitiMedia() {
    return Column(
      children: [
        if (widget.message.userImage != null) ...{
          ClipRRect(
            borderRadius: borderRadius(10.0),
            child: Image.memory(widget.message.userImage!),
          ),
          const Gap(height: 10),
        },
        if (widget.message.path != null) ...{
          WavyAudio(
            path: widget.message.path!,
            width: context.screenWidth * .64,
          ),
        },
      ],
    );
  }

  Widget _messageContent(bool isTextAnimted) {
    return widget.isFromUser
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mulitiMedia(),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: FontFamily.mainFont,
                ),
              ),
            ],
          )
        : isTextAnimted
            ? AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: <AnimatedText>[
                  TypewriterAnimatedText(
                    message,
                    textStyle: const TextStyle(
                      fontFamily: FontFamily.mainFont,
                    ),
                  )
                ],
              )
            : MarkdownBody(
                data: message,
                selectable: true,
              );
  }

  /* Uint8List? get targetImaget {
    return widget.content.parts.whereType<DataPart>().firstOrNull?.bytes;
  } */

  @override
  void initState() {
    /* Future.delayed(
      const Duration(seconds: 10),
      () {
        setState(
          () {
            isResponseEnded = false;
          },
        );
      },
    ); */
    super.initState();
  }

  double get _boxWidth =>
      widget.isFromUser ? context.screenWidth * .88 : context.screenWidth * .7;

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, _, __) {
      return Consumer<AiSettingsProvider>(builder: (context, settings, _) {
        return Consumer<ManageAiProvider>(
          builder: (context, aiChat, _) {
            bool isTextAnimted =
                widget.isLastMessage && settings.isResponseAnimated;

            return Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: widget.isFromUser
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: widget.isFromUser ? 2.0 : 10,
                        right: widget.isFromUser ? 10 : 0,
                        left: 10,
                      ),
                      constraints: BoxConstraints(maxWidth: _boxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomRight: const Radius.circular(15),
                          bottomLeft: widget.isFromUser
                              ? const Radius.circular(0)
                              : const Radius.circular(15),
                        ),
                        color: widget.isFromUser
                            ? !context.isDark
                                ? const Color(0xFF3887BE)
                                : const Color(0xFF225172)
                            : !context.isDark
                                ? const Color(0xFF9BB8CD)
                                : const Color(0xFF3e4a52),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomRight: const Radius.circular(15),
                            bottomLeft: widget.isFromUser
                                ? const Radius.circular(0)
                                : const Radius.circular(15),
                          ),
                          onLongPress: () {
                            FlutterClipboard.copy(message).whenComplete(
                              () => showToastification(
                                  title: msgCopied,
                                  type: ToastificationType.success),
                            );
                          },
                          child: Padding(
                            padding: padding(10.0),
                            child: _messageContent(isTextAnimted),
                          ),
                        ),
                      ),
                    ),
                    if (!widget.isFromUser) ...{
                      Padding(
                        padding: padding(5.0),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF9BB8CD),
                          child: Image.asset(
                            "assets/images/png/fitness_ai.png",
                          ),
                        ),
                      )
                    }
                  ],
                ),
                if (widget.isFromUser) ...{
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Gap(wRatio: 0.03),
                      Text(
                        widget.messageTime.formatMessageTime,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF9e9e9e),
                          fontFamily: FontFamily.mainFont,
                        ),
                      ),
                    ],
                  )
                },
              ],
            );
          },
        );
      });
    });
  }
}
