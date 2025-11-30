import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/constants/assets.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/full_image_dialog.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/format_message_time.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/texts.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/wavy_audio.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/amigo_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    required this.isFromUser,
    /*  required this.message, */
    //  required this.content,
    required this.isLastMessage,
    required this.messageTime,
    required this.message,
  });

  /*  final String message; */
  // final Content content;
  final DateTime messageTime;
  final bool isFromUser;
  final bool isLastMessage;
  final MessageModel message;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isResponseEnded = false;

  static const int _animatedTxtDuration = 3;

  void _normlizeText() {
    Future.delayed(
      const Duration(seconds: _animatedTxtDuration),
      () {
        setState(
          () => isResponseEnded = true,
        );
      },
    );
  }

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
            child: Clicker(
              onClick: () async {
                await showFullImageDialog(widget.message.userImage!);
              },
              child: Image.memory(widget.message.userImage!),
            ),
          ),
          const Gap(height: 10),
        },
        if (widget.message.path != null) ...{
          WavyAudio(
            path: widget.message.path!,
            bgColor: SwitchColors.accent,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        : !isResponseEnded && isTextAnimted
            ? AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: <AnimatedText>[
                  TypewriterAnimatedText(
                    message,
                    //speed: const Duration(seconds: _animatedTxtDuration),
                    textStyle: const TextStyle(
                      fontFamily: FontFamily.mainFont,
                    ),
                  )
                ],
              )
            : MarkdownBody(data: message, selectable: true);
  }

  @override
  void initState() {
    _normlizeText();
    super.initState();
  }

  double get _boxWidth =>
      widget.isFromUser ? context.screenWidth * .88 : context.screenWidth * .8;

  BorderRadius _userRaduis({double raduis = 15.0}) => BorderRadius.only(
        topLeft: Radius.circular(raduis),
        topRight: Radius.circular(raduis),
        bottomRight: Radius.circular(raduis),
        bottomLeft: widget.isFromUser
            ? const Radius.circular(0)
            : Radius.circular(raduis),
      );
  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    return Consumer<AiSettingsProvider>(
      builder: (context, settings, _) {
        return Consumer<ManageAiProvider>(
          builder: (context, aiChat, _) {
            bool isTextAnimted =
                widget.isLastMessage && settings.isResponseAnimated;

            return Column(
              crossAxisAlignment: widget.isFromUser
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
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
                        borderRadius: _userRaduis(
                          raduis: widget.isFromUser ? 25.0 : 15.0,
                        ),
                        color: widget.isFromUser
                            ? SwitchColors.secondary
                            : SwitchColors.primary,
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
                          child: Image.asset(Assets.logo),
                        ),
                      )
                    }
                  ],
                ),
                if (widget.isFromUser) ...{
                  Container(
                    margin: EdgeInsets.only(left: context.screenWidth * .03),
                    padding: padding(5.0),
                    decoration: BoxDecoration(
                      borderRadius: _userRaduis(),
                      color: SwitchColors.opcColor,
                      border: Border.all(color: SwitchColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /* const Gap(wRatio: 0.03), */
                        Text(
                          widget.messageTime.formatMessageTime,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            color: SwitchColors.text,
                            fontFamily: FontFamily.mainFont,
                          ),
                        ),
                      ],
                    ),
                  )
                },
              ],
            );
          },
        );
      },
    );
  }
}
