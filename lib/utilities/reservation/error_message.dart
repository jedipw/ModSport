import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.error, size: 100, color: primaryGray),
            SizedBox(height: 20),
            Text(
              'Something went wrong!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5, // 21/14 = 1.5
                color: primaryGray,
                letterSpacing: 0,
              ),
            ),
            Text(
              'Please try again later.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5, // 21/14 = 1.5
                color: primaryGray,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
