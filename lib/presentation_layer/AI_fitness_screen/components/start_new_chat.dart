import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/text_styles.dart';
import 'package:flutter/material.dart';

class StartNewChatWidget extends StatelessWidget {
  const StartNewChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TweenAnimationBuilder(
            tween: Tween<double>(begin: .5, end: .9),
            duration: const Duration(milliseconds: 2300),
            builder: (context, size, _) {
              return SizedBox(
                width: context.screenWidth * size,
                height: context.screenHeight * .3,
                child: Image.asset(
                  "assets/images/png/fitness_ai.png",
                ),
              );
            },
          ),
          SizedBox(
            width: context.screenWidth * .96,
            height: context.screenHeight * .15,
            child: AnimatedTextKit(
              repeatForever: true,
              pause: const Duration(milliseconds: 1200),
              animatedTexts: <AnimatedText>[
                TypewriterAnimatedText(
                  welcom,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.mainFont,
                  ),
                ),
              ],
            ),
          ),
          const Gap(hRatio: 0.01),
          const Text(
            subWelcome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.mainFont,
            ),
          ),
        ],
      ),
    );
  }
}
