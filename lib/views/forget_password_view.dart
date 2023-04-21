import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      // scaffold widget provides a basic app bar, drawer and body
      appBar: AppBar(
        title: const Text('Forget Password'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ), // app bar with a title
      body: Center(
        // centers child widget in the screen
        child: TextButton(
          // a flat button with a text label
          style: ButtonStyle(
              // style the button
              backgroundColor: MaterialStateProperty.all(
                  Colors.orange)), // set button background color
          onPressed: () {
            // method called when button is pressed
            Navigator.of(context).pushNamedAndRemoveUntil(
              // navigates to homeRoute screen and removes previous routes
              loginRoute,
              (route) => false,
            );
          },
          child: const Text(
            // label text for the button
            "Reset Password!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
