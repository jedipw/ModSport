import 'package:flutter/material.dart';
import 'package:modsport/constants/mode.dart';

typedef OnPressedCallBack = Function();

class FinishButton extends StatelessWidget {
  final String reason;
  final String mode;

  final int numOfCharacter;

  final TextEditingController reasonController;

  final OnPressedCallBack onPressed;

  const FinishButton({
    super.key,
    required this.onPressed,
    required this.numOfCharacter,
    required this.mode,
    required this.reasonController,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          numOfCharacter < 10 ||
                  numOfCharacter > 250 ||
                  (mode == editMode && reasonController.text == reason)
              ? const Color.fromRGBO(241, 185, 146, 0.5)
              : const Color.fromRGBO(241, 185, 146, 1),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ), // Set the button background color to grey
      onPressed: numOfCharacter < 10 ||
              numOfCharacter > 250 ||
              (mode == editMode && reasonController.text == reason)
          ? null
          : onPressed,
      child: Text(
        mode == editMode ? "SAVE" : "DONE", // Set the button text to "Disable"
        style: TextStyle(
          color: numOfCharacter < 10 ||
                  numOfCharacter > 250 ||
                  (mode == editMode && reasonController.text == reason)
              ? const Color.fromRGBO(0, 0, 0, 0.2)
              : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          fontStyle: FontStyle.normal,
          height: 1.5,
        ),
      ),
    );
  }
}
