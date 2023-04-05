import 'package:flutter/material.dart';

class DisableView extends StatelessWidget {
  const DisableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disable')),
      body: const Text('Disable Page'),
    );
  }
}
