import 'package:amigo/statemanagement_layer/catch_text_local/catch_text_locale.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/theme_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  List<SingleChildWidget> providers = <SingleChildWidget>[
    ChangeNotifierProvider(create: (context) => AiSettingsProvider()),
    ChangeNotifierProvider(create: (context) => PickImage(context)),
    ChangeNotifierProvider(create: (context) => ManageAiProvider()),
    ChangeNotifierProvider(create: (context) => DetectLanguage()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
  ];

  return providers;
}
