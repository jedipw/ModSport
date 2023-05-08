import 'package:flutter/material.dart';

import 'package:modsport/constants/color.dart';

typedef OnPressedCallBack = Function();

class DisableButton extends StatelessWidget {
  final bool isDisableMenu;

  final List<bool?> selectedTimeSlots;
  
  final OnPressedCallBack onPressed;

  const DisableButton({
    Key? key,
    required this.isDisableMenu,
    required this.selectedTimeSlots,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numOfSelectedTimeSlots =
        selectedTimeSlots.where((element) => element == true).length;

    return SizedBox(
      height: 55,
      width: 140,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            const BorderSide(
              color: primaryRed,
              width: 3,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ), // Set the button background color to grey
        onPressed: onPressed,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "DISABLE", // Set the button text to "Disable"
              style: TextStyle(
                color: primaryRed,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.normal,
                height: 1.5,
              ),
            ),
            if (isDisableMenu == true && numOfSelectedTimeSlots > 1) ...[
              Text(
                ' ($numOfSelectedTimeSlots)', // Set the button text to "Disable"
                style: const TextStyle(
                  color: primaryRed,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.normal,
                  height: 1.5,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
