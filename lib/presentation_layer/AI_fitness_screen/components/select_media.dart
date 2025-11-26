import 'dart:ui';

import 'package:amigo/commons/app_dimensions.dart';
import 'package:amigo/commons/commons.dart';
import 'package:amigo/constants/gaps.dart';
import 'package:amigo/presentation_layer/AI_fitness_screen/components/recording_dialog.dart';
import 'package:amigo/statemanagement_layer/manage_AI_bot/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedaiDialogManager {
  static final OverlayPortalController controller = OverlayPortalController();

  static void showSelector() {
    if (controller.isShowing) {
      hideSelector();
      return;
    }
    controller.show();
  }

  static void hideSelector() {
    if (!controller.isShowing) {
      return;
    }
    controller.hide();
  }
}

class SelectMedia extends StatelessWidget {
  const SelectMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: MedaiDialogManager.controller,
      overlayChildBuilder: (context) {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0.4, end: 1.0),
          builder: (context, animation, child) {
            return Positioned(
              bottom: (context.screenHeight * .1) * animation,
              left: 10.0,
              child: Opacity(
                opacity: 0.4 + (0.6 * animation),
                child: Transform.scale(
                  scale: animation,
                  child: ClipRRect(
                    borderRadius: borderRadius(10.0),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                        child: Container(
                          padding: padding(5.0),
                          decoration: BoxDecoration(
                            borderRadius: borderRadius(10.0),
                            color: Colors.white30,
                            border: Border.all(color: Colors.black38),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                "Choose type",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: context.screenWidth * .4,
                                child: const Divider(),
                              ),
                              MediaItem(
                                icon: Icons.image,
                                label: "Image file",
                                onTap: () async {
                                  await context
                                      .read<PickImage>()
                                      .catchImageFromStorage()
                                      .whenComplete(() {
                                    MedaiDialogManager.hideSelector();
                                  });
                                },
                              ),
                              const Divider(),
                              MediaItem(
                                icon: Icons.multitrack_audio_rounded,
                                label: "Audio file",
                                onTap: () async {
                                  context
                                      .read<PickImage>()
                                      .clearOldAudioBeforeAddingNewOne();

                                  await context
                                      .read<PickImage>()
                                      .loadAudioFronStorage()
                                      .whenComplete(() {
                                    MedaiDialogManager.hideSelector();
                                  });
                                },
                              ),
                              const Divider(),
                              MediaItem(
                                icon: Icons.mic,
                                label: "Record Audio",
                                onTap: () async {
                                  MedaiDialogManager.hideSelector();

                                  context
                                      .read<PickImage>()
                                      .clearOldAudioBeforeAddingNewOne();

                                  await showRecordingDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: IconButton(
        onPressed: () {
          MedaiDialogManager.showSelector();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        icon: const Icon(Icons.link),
      ),
    );
  }
}

class MediaItem extends StatelessWidget {
  const MediaItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Clicker(
      onClick: onTap,
      child: Row(
        children: <Widget>[
          Icon(icon),
          const Gap(width: 6.0),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
