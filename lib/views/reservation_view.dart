import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class ReservationView extends StatelessWidget {
  const ReservationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation')),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamed(
              disableRoute,
            );
          },
          child: const Text(
            "Disable",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
