import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/data_layer/ai_models/ai_history_model.dart';
import 'package:amigo/presentation_layer/splash_screen/splash_screen.dart';
import 'package:amigo/statemanagement_layer/app_providers.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Hive.initFlutter();

  Hive.registerAdapter(MessageModelAdapter());

  runApp(const amigoRoot());
}

class amigoRoot extends StatelessWidget {
  const amigoRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      builder: (context, _) {
        return Consumer<DarkModeProvider>(
          builder: (context, appMode, _) {
            return ToastificationWrapper(
              child: MaterialApp(
                navigatorKey: navigatorKey,
                home: const SplashScreen(),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF6C22A6),
                    brightness: appMode.appBrightness,
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
