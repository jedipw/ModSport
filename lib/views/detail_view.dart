import 'package:flutter/material.dart';

// This class represents the Detail view of the app
class DetailView extends StatelessWidget {
  const DetailView({super.key});

  // This method builds the UI for the Detail view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This widget is the app bar at the top of the screen
      appBar: AppBar(title: const Text('Detail')),
      // This widget is the body of the screen, which displays the text 'Detail Page' at the center of the screen
      body: const Center(child: Text('Detail Page')),
    );
  }
}
