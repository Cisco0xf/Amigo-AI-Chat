import 'package:amigo/commons/app_dimensions.dart';
import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({
    super.key,
    this.hRatio,
    this.wRatio,
    this.height = 0.0,
    this.width = 0.0,
  });

  final double width;
  final double height;
  final double? wRatio;
  final double? hRatio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hRatio != null ? context.screenHeight * hRatio! : height,
      width: wRatio != null ? context.screenWidth * wRatio! : width,
    );
  }
}
