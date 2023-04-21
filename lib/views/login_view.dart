import 'package:flutter/material.dart';
import 'package:modsport/constants/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      // scaffold widget provides a basic app bar, drawer and body
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromARGB(255, 225, 115, 37),
      ), // app bar with a title
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // a flat button with a text label
                style: ButtonStyle(
                    // style the button
                    backgroundColor: MaterialStateProperty.all(
                        Colors.orange)), // set button background color
                onPressed: () {
                  // method called when button is pressed
                  Navigator.of(context).pushNamed(
                    registerRoute,
                  );
                },
                child: const Text(
                  // label text for the button
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                // a flat button with a text label
                style: ButtonStyle(
                    // style the button
                    backgroundColor: MaterialStateProperty.all(
                        Colors.orange)), // set button background color
                onPressed: () {
                  // method called when button is pressed
                  Navigator.of(context).pushNamed(
                    forgetPasswordRoute,
                  );
                },
                child: const Text(
                  // label text for the button
                  "Forget Password",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                // a flat button with a text label
                style: ButtonStyle(
                    // style the button
                    backgroundColor: MaterialStateProperty.all(
                        Colors.orange)), // set button background color
                onPressed: () {
                  // method called when button is pressed
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                },
                child: const Text(
                  // label text for the button
                  "Login with unverified email!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                // a flat button with a text label
                style: ButtonStyle(
                    // style the button
                    backgroundColor: MaterialStateProperty.all(
                        Colors.orange)), // set button background color
                onPressed: () {
                  // method called when button is pressed
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    // navigates to homeRoute screen and removes previous routes
                    homeRoute,
                    (route) => false,
                  );
                },
                child: const Text(
                  // label text for the button
                  "Login with verified email!",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
