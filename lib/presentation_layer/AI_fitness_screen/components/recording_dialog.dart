// ignore_for_file: use_build_context_synchronously

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/record_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wave_blob/wave_blob.dart';

Future<void> showRecordingDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: borderRadius(10.0)),
        child: const RecordingDialog(),
      );
    },
  );
}

class RecordingDialog extends StatefulWidget {
  const RecordingDialog({super.key});

  @override
  State<RecordingDialog> createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<RecordingDialog> {
  bool isRecording = false;

  bool _started = false;

  final AudioRecording _recorder = AudioRecording();

  /* String recordDuration = "00:00"; */

  @override
  void initState() {
    _recorder.initRecording();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * .4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: context.screenHeight * .2,
                  child: WaveBlob(
                    amplitude: 7250.0,
                    autoScale: true,
                    blobCount: 4,
                    overCircle: true,
                    centerCircle: true,
                    circleColors: const [
                      Colors.red,
                      Colors.green,
                    ],
                    scale: 1.0,
                    child: isRecording
                        ? LoadingAnimationWidget.beat(
                            color: Colors.teal, size: 25.0)
                        : const Icon(Icons.mic),
                  ),
                ),
                const Gap(height: 20),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: borderRadius(10.0),
                color: Colors.teal,
              ),
            ),
          ),
          RecordingButton(
            isRecording: isRecording,
            onRecord: () async {
              if (isRecording) {
                await _recorder.pauseRecorder();
              } else {
                if (_started) {
                  await _recorder.resumeRecorder();
                } else {
                  await _recorder.startRecording();
                }
              }

              _started = true;

              setState(() => isRecording = !isRecording);
            },
            onProgress: _recorder.audioRecorder.onProgress,
          ),
          RecordingControllers(
            onCancel: () async {
              await _recorder.canelRecording().whenComplete(() {
                Navigator.pop(context);
              });
            },
            onDone: () async {
              if (!_started) {
                Log.error("Not Started yet ...");
                return;
              }

              await _recorder.finishRecording(context);
            },
          )
        ],
      ),
    );
  }
}

class RecordingButton extends StatelessWidget {
  const RecordingButton({
    super.key,
    required this.onProgress,
    required this.onRecord,
    required this.isRecording,
  });

  final void Function() onRecord;
  final Stream<RecordingDisposition>? onProgress;

  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: (context.screenHeight * .14) -
          (context.screenHeight * .15) / 2, // .14 BG || 0.08 Button
      right: 0.0,
      left: 0.0,
      child: SizedBox(
        height: context.screenHeight * .12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox.square(
              dimension: context.screenHeight * .08,
              child: Clicker(
                onClick: onRecord,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(7.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.teal),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: isRecording
                        ? const Icon(Icons.stop_rounded,
                            key: ValueKey("MNSJLJKDJ-msin"))
                        : const Icon(Icons.mic,
                            key: ValueKey("MJNH-dndug-_m93")),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: /* recorder.audioRecorder. */ onProgress,
              builder: (context, snapshot) {
                const TextStyle style = TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                );
                if (snapshot.hasData && snapshot.data != null) {
                  final Duration data = snapshot.data!.duration;
                  final int minutes = data.inMinutes % 60;
                  final int seconds = data.inSeconds % 60;

                  return Text(
                    "${minutes.timerFormatter}:${seconds.timerFormatter}",
                    style: style,
                  );
                }

                Log.error("Hs no Data...");

                return const Text("00:00", style: style);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingControllers extends StatelessWidget {
  const RecordingControllers({
    super.key,
    required this.onCancel,
    required this.onDone,
  });

  final void Function() onCancel;
  final void Function() onDone;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10.0,
      right: 10.0,
      left: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius(5.0),
              color: Colors.red,
            ),
            child: Clicker(
              onClick: onCancel,
              child: const Icon(Icons.clear),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius(5.0),
              color: Colors.green,
            ),
            child: Clicker(
              onClick: onDone,
              child: const Icon(Icons.done),
            ),
          ),
        ],
      ),
    );
  }
}

extension TimerFormat on int {
  String get timerFormatter {
    final int current = this;

    String target = "00:00";

    if (current >= 0 && current < 10) {
      target = "0$current";
    } else {
      target = current.toString();
    }

    return target;
  }
}
