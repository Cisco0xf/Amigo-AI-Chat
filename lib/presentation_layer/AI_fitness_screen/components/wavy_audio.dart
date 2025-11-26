import 'dart:async';
import 'dart:ui';

import 'package:amigo/constants/app_colors.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/commons/my_logger.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class WavyAudio extends StatefulWidget {
  const WavyAudio({
    super.key,
    required this.path,
    required this.width,
    this.bgColor = Colors.black38,
  });

  final String path;
  final double width;
  final Color bgColor;

  @override
  State<WavyAudio> createState() => _WavyAudioState();
}

class _WavyAudioState extends State<WavyAudio> {
  late final PlayerController controller;
  late final StreamSubscription subscription;
  late final PlayerWaveStyle playerStyle;

  Size get _audioSize => Size(widget.width, context.screenHeight * .08);

  void _initProperties() {
    controller = PlayerController();

    playerStyle = const PlayerWaveStyle(
      // spacing: 6.0,
      fixedWaveColor: Colors.grey,
      liveWaveColor: Colors.white,
    );

    subscription =
        controller.onPlayerStateChanged.listen((_) => setState(() {}));

    controller.preparePlayer(
      path: widget.path,
      shouldExtractWaveform: false,
    );

    controller.waveformExtraction.extractWaveformData(
      path: widget.path,
      noOfSamples: playerStyle.getSamplesForWidth(widget.width),
    );
  }

  // Size get _audioSize => Size(widget.width, context.screenHeight * .08);

  /* late ManageAudioProvider _audioProvider; */

  @override
  void initState() {
    /* const PlayerWaveStyle playerStyle = PlayerWaveStyle(
      // spacing: 6.0,
      fixedWaveColor: Colors.grey,
      liveWaveColor: Colors.white,
    ); */
    /*  _audioProvider = Provider.of<ManageAudioProvider>(context, listen: false);

    _audioProvider.initProperties(
      widget.path,
      playerStyle: playerStyle,
      width: widget.width,
    ); */

    _initProperties();

    super.initState();
  }

  bool get _isPlaying => controller.playerState.isPlaying;

  @override
  void dispose() {
    controller.dispose();
    subscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius(10.0),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            padding: padding(7.0),
            decoration: BoxDecoration(
              borderRadius: borderRadius(10.0),
              color: widget.bgColor.withOpacity(0.4),
              border: Border.all(color: SwitchColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        if (_isPlaying) {
                          await controller.pausePlayer();
                        } else {
                          await controller.startPlayer();
                        }

                        controller.setFinishMode(finishMode: FinishMode.loop);
                        /* if (update.isPlaying) {
                            await update.pauseAudio();
                          } else {
                            await update.playAudio();
                          }

                          update.controller!
                              .setFinishMode(finishMode: FinishMode.loop); */
                      },
                      icon: _isPlaying
                          ? LoadingAnimationWidget.beat(
                              color: Colors.white, size: 20)
                          : const Icon(Icons.play_arrow_rounded),
                    ),
                    AudioFileWaveforms(
                      size: _audioSize,
                      playerController: controller /* update.controller! */,
                      waveformType: WaveformType.fitWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/* 
class ManageAudioProvider extends ChangeNotifier {
  PlayerController? controller;
  StreamSubscription? subscription;

  void initProperties(
    String path, {
    required PlayerWaveStyle playerStyle,
    required double width,
  }) {
    controller = PlayerController();

    subscription =
        controller?.onPlayerStateChanged.listen((_) => notifyListeners());

    controller?.preparePlayer(
      path: path,
      shouldExtractWaveform: false,
    );

    controller?.waveformExtraction.extractWaveformData(
      path: path,
      noOfSamples: playerStyle.getSamplesForWidth(width),
    );
  }

  bool get isPlaying => controller!.playerState.isPlaying;

  void disposeAudio() {
    controller?.dispose();
    subscription?.cancel();
  }

  Future<void> playAudio() async {
    try {
      await controller?.startPlayer();
    } catch (error) {
      Log.log("Controller? starting Error => Error");
    }
  }

  Future<void> pauseAudio() async {
    try {
      await controller?.pausePlayer();
    } catch (error) {
      Log.log("Error Pausing controller");
    }
  }
}
 */