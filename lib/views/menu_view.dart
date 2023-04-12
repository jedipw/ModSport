import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  // ignore: prefer_final_fields
  int _currentIndex = 2;

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
            icon: Icon(Icons.account_circle),
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
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
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
