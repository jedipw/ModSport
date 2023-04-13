import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

// This function returns a BottomNavigationBar widget with three items and specific properties.
BottomNavigationBar modSportNavBar(currentNavbarIndex, context) {
  return BottomNavigationBar(
    currentIndex:
        currentNavbarIndex, // The index of the currently selected item.
    type:
        BottomNavigationBarType.fixed, // The type of the bottom navigation bar.
    iconSize: 40, // The size of the icons.
    selectedFontSize: 0, // The font size of the selected item's label.
    unselectedFontSize: 0, // The font size of the unselected item's label.
    selectedItemColor: const Color.fromARGB(
        255, 225, 115, 37), // The color of the selected item.
    unselectedItemColor: Colors.black, // The color of the unselected items.
    items: [
      // A list of BottomNavigationBarItems.
      const BottomNavigationBarItem(
        icon: Icon(Icons.home), // The icon of the item.
        label:
            '', // The label of the item (empty string since we don't want a label).
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.rule),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: (currentNavbarIndex == 2
            ? const Icon(Icons.account_circle)
            : const Icon(Icons.account_circle_outlined)),
        label: '',
      ),
    ],
    onTap: (index) {
      // Called when an item is tapped.
      switch (index) {
        // Switch statement to determine the tapped item.
        case 0:
          Navigator.of(context).pushNamedAndRemoveUntil(
              homeRoute,
              (route) =>
                  false); // Navigates to the homeRoute and removes all previous routes.
          break;
        case 1:
          Navigator.of(context).pushNamedAndRemoveUntil(
              statusRoute,
              (route) =>
                  false); // Navigates to the statusRoute and removes all previous routes.
          break;
        case 2:
          Navigator.of(context).pushNamedAndRemoveUntil(
              menuRoute,
              (route) =>
                  false); // Navigates to the menuRoute and removes all previous routes.
          break;
      }
    },
  );
}
