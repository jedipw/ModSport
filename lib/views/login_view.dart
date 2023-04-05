import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange)),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              homeRoute,
              (route) => false,
            );
          },
          child: const Text(
            "Login!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
