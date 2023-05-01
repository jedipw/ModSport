import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';

class RegisterView extends StatelessWidget {
  const RegisterView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      // scaffold widget provides a basic app bar, drawer and body
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: primaryOrange,
      ), // app bar with a title
      body: Center(
        // centers child widget in the screen
        child: TextButton(
          // a flat button with a text label
          style: ButtonStyle(
              // style the button
              backgroundColor: MaterialStateProperty.all(
                  primaryOrange)), // set button background color
          onPressed: () {
            // method called when button is pressed
            Navigator.of(context).pushNamed(
              // navigates to homeRoute screen and removes previous routes
              verifyEmailRoute,
            );
          },
          child: const Text(
            // label text for the button
            "Register!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
