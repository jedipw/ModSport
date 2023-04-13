import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/navbar.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final int _currentNavbarIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: modSportNavBar(
          _currentNavbarIndex, context), // add the custom bottom navigation bar
      appBar: AppBar(
        title: const Text('Status'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ), // add the app bar
      body: Center(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.orange)), // set button style with background color
          onPressed: () {
            Navigator.of(context).pushNamed(
                detailRoute); // navigate to the detailed status page when button is pressed
          },
          child: const Text(
            'Detailed status',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
