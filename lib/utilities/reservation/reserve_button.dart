import 'package:flutter/material.dart';

class ReserveButton extends StatelessWidget {
  final bool
      isReserved; // Indicates if the button is for reserving or canceling a reservation
  final VoidCallback
      onPressed; // Callback function to execute when the button is pressed

  const ReserveButton({
    Key? key,
    required this.isReserved,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 140,
      child: TextButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(
              color: isReserved
                  ? const Color(0xFFCC0019)
                  : const Color(0xFFE17325),
              width: 3,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        onPressed: onPressed, // Assign the onPressed callback to the button
        child: Text(
          isReserved
              ? "CANCEL"
              : "RESERVE", // Set the button text based on the isReserved value
          style: TextStyle(
            color:
                isReserved ? const Color(0xFFCC0019) : const Color(0xFFE17325),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            fontStyle: FontStyle.normal,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
