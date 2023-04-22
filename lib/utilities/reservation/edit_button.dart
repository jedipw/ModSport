import 'package:flutter/material.dart';

typedef OnPressedCallBack = Function();

class EditButton extends StatelessWidget {
  const EditButton({Key? key, required this.onPressed}) : super(key: key);
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
              color: Color(0xFFE17325),
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
              "EDIT ALL", // Set the button text to "Disable"
              style: TextStyle(
                color: Color(0xFFE17325),
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
