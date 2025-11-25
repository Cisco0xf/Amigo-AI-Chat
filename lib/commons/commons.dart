import 'package:amigo/commons/navigation_key.dart';
import 'package:amigo/statemanagement_layer/change_app_theme/is_dark_mode.dart';
import 'package:flutter/material.dart';

enum From {
  horizontal,
  vertical,
  all,
}

enum Side {
  right,
  left,
  bottom,
  top,
  all,
}

BorderRadius borderRadius(double radius, {Side side = Side.all}) {
  switch (side) {
    case Side.all:
      {
        return BorderRadius.circular(radius);
      }
    case Side.bottom:
      {
        return BorderRadius.vertical(bottom: Radius.circular(radius));
      }
    case Side.top:
      {
        return BorderRadius.vertical(top: Radius.circular(radius));
      }
    case Side.right:
      {
        return BorderRadius.horizontal(right: Radius.circular(radius));
      }
    case Side.left:
      {
        return BorderRadius.horizontal(left: Radius.circular(radius));
      }
  }
}

EdgeInsetsGeometry padding(double padding, {From from = From.all}) {
  switch (from) {
    case From.all:
      {
        return EdgeInsets.all(padding);
      }
    case From.horizontal:
      {
        return EdgeInsets.symmetric(horizontal: padding);
      }
    case From.vertical:
      {
        return EdgeInsets.symmetric(vertical: padding);
      }
  }
}

List<BoxShadow>? mainBoxShadow({
  double spreadRadius = 0.1,
  double blurRadius = 5.0,
  BlurStyle blurStyle = BlurStyle.normal,
}) {
  List<BoxShadow> globalBoxShadow = <BoxShadow>[
    const BoxShadow(
      spreadRadius: 0.1,
      blurRadius: 5.0,
      color: Colors.white,
      blurStyle: BlurStyle.normal,
      offset: Offset(-4, -4),
    ),
    BoxShadow(
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      color: const Color(0xFF9e9e9e),
      blurStyle: BlurStyle.normal,
      offset: const Offset(4, 4),
    ),
  ];
  final BuildContext context = navigatorKey.currentContext!;
  return context.isDark ? null : globalBoxShadow;
}

class Clicker extends StatelessWidget {
  const Clicker({
    super.key,
    required this.child,
    required this.onClick,
    this.isCircl = false,
    this.radius = 10.0,
    this.innerPadding = 5.0,
  });

  final void Function() onClick;
  final bool isCircl;
  final double radius;
  final Widget child;
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        customBorder: isCircl ? const CircleBorder() : null,
        borderRadius: isCircl ? null : borderRadius(radius),
        child: Padding(
          padding: padding(innerPadding),
          child: child,
        ),
      ),
    );
  }
}
