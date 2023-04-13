import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/navbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final int _currentNavbarIndex =
      0; // Define current selected index of the navbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: modSportNavBar(_currentNavbarIndex,
            context), // Display the navbar with the current index
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: const Color.fromARGB(255, 225, 115, 37),
        ),
        body: Center(
            child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.orange)), // Set the button background color
          onPressed: () {
            Navigator.of(context).pushNamed(
              reservationRoute,
            ); // Navigate to the reservation route
          },
          child: const Text(
            "Reservation",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )));
  }
}
