import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

class NoReservationMessage extends StatelessWidget {
  const NoReservationMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.event_busy, size: 100, color: primaryGray),
        SizedBox(height: 20),
        Text(
          'Sorry, we don\'t have any',
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
          'reservations available for this date.',
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
    );
  }
}
