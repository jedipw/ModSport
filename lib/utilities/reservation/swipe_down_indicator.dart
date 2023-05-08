import 'dart:math';

import 'package:flutter/material.dart';

class SwipeDownIndicator extends StatelessWidget {
  const SwipeDownIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: 10 * (pi / 180), // convert 30 degrees to radians
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              color: Color(0xFFD9D9D9),
            ),
            height: 5,
            width: 25,
          ),
        ),
        Transform.rotate(
          angle: 350 * (pi / 180), // convert 30 degrees to radians
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Color(0xFFD9D9D9),
            ),
            height: 5,
            width: 25,
          ),
        ),
      ],
    );
  }
}
