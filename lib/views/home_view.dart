import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 40,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: const Color.fromARGB(255, 225, 115, 37),
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rule),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                break;
              case 1:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(statusRoute, (route) => false);
                break;
              case 2:
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(menuRoute, (route) => false);
                break;
            }
          },
        ),
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
