import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

BottomNavigationBar modSportNavBar(currentIndex, context) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
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
  );
}
