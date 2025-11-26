// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/commons/show_toastification.dart';
import 'package:amigo/constants/text_styles.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AudioRecording {
  static const String _formate = ".aac";
  // Check mic permission

  Future<bool> get checkMicPermission async {
    final PermissionStatus micStatus = await Permission.microphone.status;

    final bool isGraneted = micStatus == PermissionStatus.granted;

    if (!isGraneted) {
      await Permission.microphone.request();
      return false;
    }

    return true;
  }

  // Init the Recorder

  final FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();

  bool _isRecorderReady = false;

  String? audioFilePath;

  Future<void> initRecording() async {
    final bool hasPermission = await checkMicPermission;

    if (!hasPermission) {
      showToastification(
        title: micPermission,
        type: ToastificationType.warning,
      );
      return;
    }

    try {
      await audioRecorder.openRecorder().whenComplete(() {
        _isRecorderReady = true;

        Log.log("Recorder is Ready now ...");
      });

      audioRecorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );
    } catch (error) {
      Log.error("Recorder error => $error");
    }
  }

  // Start recording

  Future<void> startRecording() async {
    if (!_isRecorderReady) {
      Log.error("Recorder is not ready ...");
      return;
    }

    audioFilePath =
        "${Directory.systemTemp.path}/audio_${DateTime.now().millisecond}$_formate";

    Log.log("Start Recording to file => $audioFilePath");

    try {
      await audioRecorder.startRecorder(
        toFile: audioFilePath,
        codec: Codec.aacADTS,
      );
    } catch (error) {
      Log.error("Error while Start recording => $error");
    }
  }

  // Stop recording

  Future<void> finishRecording(BuildContext context) async {
    if (!_isRecorderReady) {
      Log.error("Recorder is not ready ...");
      return;
    }
    try {
      final String? target = await audioRecorder.stopRecorder();

      if (target == null || target.isEmpty) {
        Log.error("Empty Path Target ...");
        return;
      }

      await Provider.of<PickImage>(context, listen: false)
          .getRecordedAudioHook(target)
          .whenComplete(
            () => Navigator.pop(context),
          );

      Log.log("Record has been saved to $target");
    } catch (error) {
      Log.error("Error while stopping");
    }
  }

  Future<void> pauseRecorder() async {
    if (!_isRecorderReady) {
      Log.error("Recorder is not ready ...");
      return;
    }
    try {
      await audioRecorder.pauseRecorder();
    } catch (error) {
      Log.error("Pausing error => $error");
    }
  }

  Future<void> resumeRecorder() async {
     if (!_isRecorderReady) {
      Log.error("Recorder is not ready ...");
      return;
    }
    try {

      await audioRecorder.resumeRecorder();
      
    } catch (error) {
       Log.error("Pausing error => $error");

    }
  }

  // Dispose the recorder

  Future<void> canelRecording() async {
    if (!_isRecorderReady) {
      Log.error("Recorder is not ready ...");
      return;
    }
    try {
      await audioRecorder.closeRecorder();
    } catch (error) {
      Log.error("Error cancel => $error");
    }
  }
}
