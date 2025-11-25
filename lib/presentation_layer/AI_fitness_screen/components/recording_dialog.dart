import 'package:amigo/constants/gaps.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/record_manager.dart';
import 'package:flutter/material.dart';

Future<void> showRecordingDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return const Dialog(
        child: RecordingDialog(),
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

  final AudioRecording _recorder = AudioRecording();

  @override
  void initState() {
    _recorder.initRecording();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        isRecording ? const Text("Recording...") : const Text("Ready..."),
        const Gap(height: 20),
        IconButton(
          onPressed: () async {
            if (isRecording) {
              await _recorder.finishRecording(context);
            } else {
              await _recorder.startRecording();
            }

            setState(() => isRecording = !isRecording);
          },
          icon:
              isRecording ? const Icon(Icons.recommend) : const Icon(Icons.mic),
        )
      ],
    );
  }
}
