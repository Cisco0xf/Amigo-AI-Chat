import 'package:amigo/commons/commons.dart';
import 'package:flutter/material.dart';

class PopScreenWidget extends StatelessWidget {
  const PopScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding(10.0),
      decoration: BoxDecoration(
        color: Colors.white38.withOpacity(0.5),
        borderRadius: borderRadius(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: padding(4.0),
          child: InkWell(
            borderRadius: borderRadius(8.0),
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
