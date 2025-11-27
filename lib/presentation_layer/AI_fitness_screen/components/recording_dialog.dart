// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/commons/my_logger.dart';
import 'package:amigo/constants/app_colors.dart';
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
        backgroundColor: Colors.transparent,
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

  @override
  void initState() {
    _recorder.initRecording();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius(20.0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: context.screenHeight * .4),
            decoration: BoxDecoration(
              color: SwitchColors.opcColor /* .withOpacity(0.4) */,
              borderRadius: borderRadius(20.0),
              border: Border.all(color: SwitchColors.border),
            ),
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
                          circleColors: <Color>[
                            Colors.red.withOpacity(0.9),
                            Colors.green.withOpacity(0.9),
                          ],
                          scale: 1.0,
                          child: isRecording
                              ? LoadingAnimationWidget.beat(
                                  color: SwitchColors.secondary, size: 25.0)
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
                      borderRadius: borderRadius(20.0),
                      color: SwitchColors.secondary.withOpacity(0.5),
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
                /*   onProgress: _recorder.audioRecorder.onProgress, */
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
          ),
        ),
      ),
    );
  }
}

class RecordingButton extends StatefulWidget {
  const RecordingButton({
    super.key,
    /* required this.onProgress, */
    required this.onRecord,
    required this.isRecording,
  });

  final void Function() onRecord;
  /* final Stream<RecordingDisposition>? onProgress; */

  final bool isRecording;

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  int seconds = 0;
  int minutes = 0;

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
                onClick: widget.onRecord,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(10.0),
                    color: SwitchColors.opcColor,
                    border: Border.all(
                      color: SwitchColors.accent.withOpacity(0.5),
                    ),
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
                    child: widget.isRecording
                        ? const Icon(Icons.stop_rounded,
                            key: ValueKey("MNSJLJKDJ-msin"))
                        : const Icon(Icons.mic,
                            key: ValueKey("MJNH-dndug-_m93")),
                  ),
                ),
              ),
            ),
            /* StreamBuilder(
              stream: widget.onProgress,
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

                // Log.error("Hs no Data...");

                return const Text("00:00", style: style);
              },
            ), */
            StreamBuilder(
              stream: Stream.periodic(
                const Duration(seconds: 1),
                (_) {
                  if (!widget.isRecording) {
                    return;
                  }

                  seconds += 1;

                  if (seconds >= 60) {
                    seconds = 0;
                    minutes++;
                  }
                },
              ),
              builder: (context, snapshot) {
                final String timer =
                    "${minutes.timerFormatter}:${seconds.timerFormatter}";
                return Text(
                  timer,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            )
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
      right: 20.0,
      left: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius(10.0),
              color: Colors.red.withOpacity(0.6),
            ),
            child: Clicker(
              onClick: onCancel,
              innerPadding: 12.0,
              child: const Icon(Icons.clear),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius(10.0),
              color: SwitchColors.accent.withOpacity(0.6),
            ),
            child: Clicker(
              onClick: onDone,
              innerPadding: 12.0,
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
