import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/navbar.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  // ignore: prefer_final_fields
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: modSportNavBar(_currentIndex, context),
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
