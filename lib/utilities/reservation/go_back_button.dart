import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        shape: const CircleBorder(),
        elevation: 5,
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
        fixedSize: const Size.fromRadius(25),
      ),
      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
    );
  }
}
