import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          IconButton(
            icon: Icon(Icons.dehaze),
            onPressed: null,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  reservationRoute,
                );
              },
              child: const Text(
                "Reservation",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  statusRoute,
                  (route) => false,
                );
              },
              child: const Text(
                "Status",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange)),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  menuRoute,
                  (route) => false,
                );
              },
              child: const Text(
                "Menu",
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
