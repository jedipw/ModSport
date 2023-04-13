import 'package:flutter/material.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ), // Defines the app bar with title "Help Center"
      body: const Center(
          child: Text(
              'Help Center Page')), // Shows the text "Help Center Page" in the center of the screen
    );
  }
}
