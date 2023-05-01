import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

typedef OnPressedCallBack = Function();

class EnableButton extends StatelessWidget {
  const EnableButton({Key? key, required this.onPressed}) : super(key: key);
  final OnPressedCallBack onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 140,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            const BorderSide(
              color: primaryGreen,
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
          children: const [
            Text(
              "ENABLE ALL", // Set the button text to "Disable"
              style: TextStyle(
                color: primaryGreen,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.normal,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
