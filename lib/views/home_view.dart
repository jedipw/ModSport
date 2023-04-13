import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/navbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // ignore: prefer_final_fields
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: modSportNavBar(_currentIndex, context),
        appBar: AppBar(
          title: const Text('Home'),
          actions: const [
            IconButton(
              icon: Icon(Icons.dehaze),
              onPressed: null,
            )
          ],
        ),
        body: Center(
            child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamed(
              reservationRoute,
            );
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
