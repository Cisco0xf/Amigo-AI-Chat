import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/constants/app_colors.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/splash_screen/splash_screen.dart';
import 'package:amigo/statemanagement_layer/app_providers.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Hive.initFlutter();

  Hive.registerAdapter(MessageModelAdapter());

  runApp(const AmigoRoot());

  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
}

class AmigoRoot extends StatelessWidget {
  const AmigoRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      builder: (context, _) {
        return Consumer<ThemeProvider>(
          builder: (context, theme, _) {
            return ToastificationWrapper(
              child: MaterialApp(
                navigatorKey: navigatorKey,
                home: const SplashScreen(),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  scaffoldBackgroundColor: SwitchColors.bgColor,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: SwitchColors.secondary,
                    brightness: theme.brightness,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
