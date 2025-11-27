import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';

enum UpdateType {
  audio,
  image,
}

class PickMediaProvider extends ChangeNotifier {
  // Chek Storage Premission

  final BuildContext context;

  PickMediaProvider(this.context);

  Future<bool> _checkStoragePermission(UpdateType type) async {
    final PermissionStatus storage = await Permission.storage.status;

    bool isGranted = storage == PermissionStatus.granted;

    if (!isGranted) {
      await Permission.storage.request().whenComplete(() async {
        if (type == UpdateType.image) {
          await catchImageFromStorage();

          return;
        }

        await loadAudioFronStorage();
      });
    }

    return isGranted;
  }

  // Upload Image as xfile

  Uint8List? convertedImage;

  Future<void> catchImageFromStorage() async {
    final bool hasPermission = await _checkStoragePermission(UpdateType.image);

    if (!hasPermission) {
      showToastification(title: requestPermi, type: ToastificationType.warning);

      return;
    }
    final ImagePicker picker = ImagePicker();

    XFile? target = await picker.pickImage(source: ImageSource.gallery);

    if (target == null) {
      Log.log("No Image Picked..", color: LColor.white);
      return;
    }

    final File image = File(target.path);

    convertedImage = await image.readAsBytes();

    notifyListeners();
  }

  // Upload Audio

  Uint8List? loadedAudio;
  String? audioPath;
  bool loadingAudio = false;

  Future<void> loadAudioFronStorage() async {
    final bool hasPermission = await _checkStoragePermission(UpdateType.audio);

    if (!hasPermission) {
      showToastification(title: requestPermi, type: ToastificationType.warning);

      return;
    }

    final FilePickerResult? pickAudio = await FilePicker.platform.pickFiles();

    if (pickAudio == null) return;

    final String? exten = pickAudio.files[0].extension;

    final bool hasEx = exten != null;

    if (!hasEx) {
      Log.log("Has no extension...", color: LColor.red);
      return;
    }

    final String target = pickAudio.files[0].path!;

    audioPath = target;

    notifyListeners();

    Log.log("Catched Path => $target");

    try {
      loadingAudio = true;
      notifyListeners();

      final File audioFile = File(target);

      loadedAudio = await audioFile.readAsBytes();

      notifyListeners();
    } catch (error) {
      Log.log("Loading Audio Error => $error", color: LColor.red);
    } finally {
      loadingAudio = false;
      notifyListeners();
    }
  }

  Future<void> getRecordedAudioHook(String recordPath) async {
    final File file = File(recordPath);
    loadedAudio = await file.readAsBytes();

    audioPath = recordPath;

    notifyListeners();
  }

  void clearImage() {
    convertedImage = null;
    notifyListeners();
  }

  Future<void> clearAudio() async {
    loadedAudio = null;
    audioPath = null;
    //await context.read<ManageAudioProvider>().pauseAudio();
    notifyListeners();
  }

  void clearOldAudioBeforeAddingNewOne() {
    if (loadedAudio != null || audioPath != null) {
      clearAudio();
    }
  }
}
