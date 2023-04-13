import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/navbar.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final int _currentNavbarIndex = 2;

  @override
  Widget build(BuildContext context) {
    // Scaffold widget is used to create the basic structure of the page
    return Scaffold(
      bottomNavigationBar: modSportNavBar(_currentNavbarIndex, context),
      appBar: AppBar(
          title: const Text(
              'Menu')), // AppBar widget is used to display the title of the page
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                // Navigate to login page and remove all the routes in the stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text(
                "Log out!",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                // Navigate to Help Center page
                Navigator.of(context).pushNamed(
                  helpCenterRoute,
                );
              },
              child: const Text(
                "Help Center",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
