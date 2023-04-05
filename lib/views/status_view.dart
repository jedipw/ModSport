import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamed(
              detailRoute,
            );
          },
          child: const Text(
            'Detailed status',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
