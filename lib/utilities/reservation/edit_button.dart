import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key, required this.isDisableMenu}) : super(key: key);
  final bool isDisableMenu;

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

        onPressed: () {
          Navigator.of(context).pushNamed(
            disableRoute, // Navigate to the disableRoute when the button is pressed
          );
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "EDIT", // Set the button text to "Disable"
              style: TextStyle(
                color: Color(0xFFE17325),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontStyle: FontStyle.normal,
                height: 1.5,
              ),
            ),
            if (isDisableMenu) ...[
              const Text(
                " ALL", // Set the button text to "Disable"
                style: TextStyle(
                  color: Color(0xFFE17325),
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
