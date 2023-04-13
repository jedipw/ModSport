import 'package:flutter/material.dart';

// A stateless widget for the disable view
class DisableView extends StatelessWidget {
  const DisableView({super.key});

  // The build method returns a Scaffold widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // An app bar with a title
      appBar: AppBar(
        title: const Text('Disable'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ),
      // A Center widget containing a Text widget
      body: const Center(
        child: Text('Disable Page'),
      ),
    );
  }
}
