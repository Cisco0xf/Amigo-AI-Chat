import 'package:amigo/presentation_layer/AI_fitness_screen/components/wavy_audio.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/calculate_bmi_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_height_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/get_bmi_info_provider.dart';
import 'package:amigo/statemanagement_layer/BMI_calculator/select_bim_gender.dart';
import 'package:amigo/statemanagement_layer/catch_text_local/catch_text_locale.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/set_dark_model_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_fitness_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/ai_settings_provider.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders {
  List<SingleChildWidget> providers = <SingleChildWidget>[
    ChangeNotifierProvider(create: (context) => SelectBMIGenderProvider()),
    ChangeNotifierProvider(create: (context) => GetBMIHeightProvider()),
    ChangeNotifierProvider(create: (context) => CalcualteBMIProvider()),
    ChangeNotifierProvider(create: (context) => BMIInfoProvider()),
    ChangeNotifierProvider(create: (context) => ManageAiProvider()),
    ChangeNotifierProvider(create: (context) => ManageAudioProvider()),
    ChangeNotifierProvider(create: (context) => AiSettingsProvider()),
    ChangeNotifierProvider(create: (context) => CatchTextLocalProvider()),
    ChangeNotifierProvider(create: (context) => DarkModeProvider()),
    ChangeNotifierProvider(create: (context) => PickImage(context))
  ];

  return providers;
}
