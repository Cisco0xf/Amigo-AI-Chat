import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_fonts.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/ai_fitness_main_screen.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _pushToMainScreen() {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.of(navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const AiFitnessMainScreen();
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _pushToMainScreen();
    /* ManageChatHistoryProvider manageChatDatabase =
        Provider.of<ManageChatHistoryProvider>(
      context,
      listen: false,
    );
    manageChatDatabase.initializeChatHistory; */

    //InitDatabases.initDatabases(context);

    AiSettingsProvider settings = Provider.of<AiSettingsProvider>(
      context,
      listen: false,
    );
    settings.initalizeSettingsData;

    DarkModeProvider appMode = Provider.of<DarkModeProvider>(
      context,
      listen: false,
    );
    appMode.initalizeAppMode;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: context.isDark
              ? const Color(0xFF457b9d)
              : const Color(0xFFE0F4FF),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: context.screenHeight * .3,
                ),
                SizedBox(
                  width: context.screenWidth * .8,
                  height: context.screenHeight * .3,
                  child: Image.asset(
                    "assets/images/png/app_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const Text(
                  "PowerPath ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.mainFont,
                    fontSize: 30,
                  ),
                ),
                const Gap(hRatio: 0.05),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
