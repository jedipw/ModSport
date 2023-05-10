import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/mode.dart';

typedef OnPressedCallBack = Function();

class DisableCloseButton extends StatelessWidget {
  final OnPressedCallBack onPressed;
  final String mode;
  const DisableCloseButton({
    super.key,
    required this.onPressed,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: mode == editMode ? Colors.white : staffOrange,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: const CircleBorder(),
        fixedSize: const Size.fromRadius(25),
        elevation: 0,
      ),
      child: Icon(Icons.close,
          color: mode == editMode ? staffOrange : Colors.white, size: 40),
    );
  }
}
