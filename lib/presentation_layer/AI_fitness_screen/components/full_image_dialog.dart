import 'dart:typed_data';

import 'package:amigo/commons/commons.dart';
import 'package:amigo/commons/navigation_key.dart';
import 'package:flutter/material.dart';

Future<void> showFullImageDialog(Uint8List image) async {
  final BuildContext context = navigatorKey.currentContext as BuildContext;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog.fullscreen(
        child: _FullImage(image: image),
      );
    },
  );
}

class _FullImage extends StatelessWidget {
  const _FullImage({required this.image});

  final Uint8List image;
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: ClipRRect(
        borderRadius: borderRadius(20.0),
        child: Container(
          padding: padding(20.0),
          child: Image.memory(image),
        ),
      ),
    );
  }
}
