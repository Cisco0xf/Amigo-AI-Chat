import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/assets.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/push_message_widget.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/constants/texts.dart';
import 'package:flutter/material.dart';

class StartNewChatWidget extends StatelessWidget {
  const StartNewChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const Gap(height: 10.0),
          /* TweenAnimationBuilder(
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
          ), */
          const AnimatedLogo(),
          SizedBox(
            width: context.screenWidth * .96,
            child: AnimatedTextKit(
              repeatForever: false,
              totalRepeatCount: 3,
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
          Padding(
            padding: padding(10.0),
            child: const Text(
              subWelcome,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontFamily.mainFont,
              ),
            ),
          ),
          const Gap(hRatio: 0.01),
          const PushMessageToAIWidget(init: true),
          const Gap(height: 30.0),
        ],
      ),
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  void _initAnimationProperties() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _animation = Tween<double>(begin: 0.0, end: 20.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void initState() {
    _initAnimationProperties();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, -_animation.value),
          child: SizedBox(
            height: context.screenHeight * .35,
            width: context.screenWidth * .8,
            child: Image.asset(Assets.logo),
          ),
        );
      },
    );
  }
}
