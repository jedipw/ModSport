import 'package:flutter/material.dart';

// This class represents the Detail view of the app
class DetailView extends StatelessWidget {
  const DetailView(
      {super.key, required this.zoneId, required this.startDateTime});

  final String zoneId;
  final DateTime startDateTime;

  // This method builds the UI for the Detail view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This widget is the app bar at the top of the screen
      appBar: AppBar(
        title: const Text('Detailed Status'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ),
      // This widget is the body of the screen, which displays the text 'Detail Page' at the center of the screen
      body:
          Center(child: Text('Zone ID: $zoneId \n Start time: $startDateTime')),
    );
  }
}
