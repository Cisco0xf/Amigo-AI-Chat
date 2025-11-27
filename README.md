# Amigo AI Chat Bot


<div align="center">
  <img width="300" height="300" alt="playstore" src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/assets/images/png/logo_face.png" />
<div align="center">

<p align="center">
   Amigo.ai | By Mahmoud Alshehyby
</p>

<div align="start">

#


***A powerful Flutter-based AI chatbot powered by Google Gemini that supports text, image, and audio inputs. Built with clean architecture and modern Flutter practices.***


## Screenshots:


<table>
   <tr>
    <td align="center"><b>Spalsh Screen</b></td>
    <td align="center"><b>Main Screen</b></td>
    <td align="center"><b>Details screen</b></td>
  </tr>
  
  <tr>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/1.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/2.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/3.webp?raw=true" alt="Screen" width="300"/></td>
  </tr>
 

</table>

<table>
   <tr>
    <td align="center"><b>Spalsh Screen</b></td>
    <td align="center"><b>Main Screen</b></td>
    <td align="center"><b>Details screen</b></td>
  </tr>
  
  <tr>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/4.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/5.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/6.webp?raw=true" alt="Screen" width="300"/></td>
  </tr>
 

</table>

<table>
   <tr>
    <td align="center"><b>Spalsh Screen</b></td>
    <td align="center"><b>Main Screen</b></td>
    <td align="center"><b>Details screen</b></td>
  </tr>
  
  <tr>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/7.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/8.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/9.webp?raw=true" alt="Screen" width="300"/></td>
  </tr>
 

</table>

<table>
   <tr>
    <td align="center"><b>Spalsh Screen</b></td>
    <td align="center"><b>Main Screen</b></td>
  </tr>
  
  <tr>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/10.webp?raw=true" alt="Screen" width="300"/></td>
    <td><img src="https://github.com/Cisco0xf/Amigo-AI-Chat/blob/main/app_screens/11.webp?raw=true" alt="Screen" width="300"/></td>
  </tr>
 

</table>



## Code Structure:

```text
lib/
├── commons/                    # Shared utilities
│   ├── app_dimensions.dart     # Responsive sizing
│   ├── commons.dart            # Common functions
│   ├── format_message_time.dart # Time formatting
│   ├── my_logger.dart          # Custom logging
│   ├── navigation_key.dart     # Global navigation
│   └── show_toastification.dart # Toast notifications
│
├── constants/                  # App constants
│   ├── api_constants.dart      # API keys & endpoints
│   ├── app_colors.dart         # Color palette
│   ├── app_fonts.dart          # Typography
│   ├── assets.dart             # Asset paths
│   ├── gaps.dart               # Spacing constants
│   └── texts.dart              # Static strings
│
├── data_layer/                 # Data & Business Logic
│   ├── ai_models/              # AI data models
│   │   ├── ai_history_model.dart
│   │   └── ai_history_model.g.dart
│   │
│   ├── database/               # Local database
│   │   └── ai_history_database.dart
│   │
│   └── save_last_data/         # Preferences
│       ├── prefs_keys.dart
│       ├── save_last_data.dart
│       └── save_prefs.dart
│
├── presentation_layer/         # UI Layer
│   ├── AI_fitness_screen/      # Main chat screen
│   │   ├── ai_chat_settings/   # Settings dialogs
│   │   │   ├── dev_section.dart
│   │   │   ├── settings_widget.dart
│   │   │   ├── show_clear_dialog.dart
│   │   │   ├── show_exit_dialog.dart
│   │   │   └── show_settings_dialog.dart
│   │   │
│   │   ├── components/         # Chat UI components
│   │   │   ├── chat_widget.dart
│   │   │   ├── full_image_dialog.dart
│   │   │   ├── message_widget.dart
│   │   │   ├── push_message_widget.dart
│   │   │   ├── recording_dialog.dart
│   │   │   ├── select_media.dart
│   │   │   ├── show_error_dialog.dart
│   │   │   ├── start_new_chat.dart
│   │   │   └── wavy_audio.dart
│   │   │
│   │   └── ai_fitness_main_screen.dart
│   │
│   ├── splash_screen/          # App entry point
│   │   └── splash_screen.dart
│   │
│   └── statemanagement_layer/  # State Management
│       ├── catch_text_local/
│       │   └── catch_text_locale.dart
│       │
│       ├── change_app_theme/
│       │   ├── is_dark_mode.dart
│       │   └── theme_provider.dart
│       │
│       └── manage_AI_bot/
│           ├── ai_fitness_provider.dart
│           ├── ai_settings_provider.dart
│           ├── pick_image.dart
│           └── record_manager.dart
│
└── main.dart                   # App entry point

```


##  Features

-  **Multimodal Chat**: Send text, images, and audio messages
-  **Audio Recording**: Record and send voice messages with waveform visualization
-  **Image Support**: Send images from locale storage
-  **Local Storage**: Chat history saved locally using `Hive`
-  **Theme Switching**: Beautiful dark/light mode with smooth transitions
-  **Custom UI**: Polished interface with message bubbles and media previews
-  **Real-time Responses**: Fast AI responses powered by Gemini 2.0 Flash

## Dependencies:

```yaml
dependencies:
  animated_text_kit: ^4.2.2
  audio_waveforms: ^2.0.0
  auto_lang_field: ^0.0.1
  clipboard: ^0.1.3
  cupertino_icons: ^1.0.8
  file_picker: ^8.1.4
  flutter:
    sdk: flutter
  flutter_dotenv: ^6.0.0
  flutter_markdown: ^0.7.4+1
  flutter_sound: ^9.28.0
  flutter_svg: ^2.0.10+1
  fluttertoast: ^8.2.8
  font_awesome_flutter: ^10.9.0
  google_generative_ai: ^0.4.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  http: ^1.2.2
  image_picker: ^1.1.2
  intl: ^0.19.0
  loading_animation_widget: ^1.3.0
  lottie: ^3.1.3
  permission_handler: ^12.0.1
  provider: ^6.1.2
  shared_preferences: ^2.3.2
  syncfusion_flutter_gauges: ^27.1.55
  toastification: ^2.3.0
  url_launcher: ^6.3.1
  wave_blob: ^1.0.5

dev_dependencies:
  build_runner: ^2.4.13
  flutter_lints: ^4.0.0
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1

```

## Getting Started:

### 1- Prerequisites
  - Flutter SDK: >=3.0.0
  - Dart SDK: >=3.0.0
  - Google Gemini API Key

### 2- Installation

  ```bash
  git clone https://github.com/yourusername/ai-fitness-chat.git
  ```

### 3- Install dependencies:

```bash
flutter pub get
```

### 4- Get yourself an `API_KEY`
1- Hit [Google AI Stodio](https://aistudio.google.com/)

2- Create a new `API_KEY` and copy it

3- Create `.env` file in the project

4- Create a variable in the `.env` file `GEMINI_API_KEY = "YOUR_API_KEY"`


## License

This project is licensed under **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)**.

### ✅ You CAN:
- View and study the code
- Use it for learning purposes
- Fork it for personal projects
- Modify it for educational use

### ❌ You CANNOT:
- Use it for commercial purposes
- Sell this code or derivatives
- Use it in paid products/services

For the full license text, see [LICENSE](https://creativecommons.org/licenses/by-nc/4.0/)

---

**For commercial use inquiries, contact me at: mahmoudalshehyby@gmail.com**




