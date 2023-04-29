import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';

class LoginView extends StatelessWidget {
  const LoginView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(40, 90, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/modsportlogoorange.png',
                  scale: 25,
                ),
                const Text(
                  "LOG IN",
                  style: TextStyle(
                    color: primaryOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
            const Text(
              "Please sign in to continue",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 16,
                height: 1.5,
                color: primaryGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      const SizedBox(height: 150),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                // a flat button with a text label
                style: ButtonStyle(
                    // style the button
                    backgroundColor: MaterialStateProperty.all(
                        primaryOrange)), // set button background color
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
                        primaryOrange)), // set button background color
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
                        primaryOrange)), // set button background color
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
                        primaryOrange)), // set button background color
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
    ]));

    // Navigation to other 4 pages
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         TextButton(
    //           // a flat button with a text label
    //           style: ButtonStyle(
    //               // style the button
    //               backgroundColor: MaterialStateProperty.all(
    //                   primaryOrange)), // set button background color
    //           onPressed: () {
    //             // method called when button is pressed
    //             Navigator.of(context).pushNamed(
    //               registerRoute,
    //             );
    //           },
    //           child: const Text(
    //             // label text for the button
    //             "Register",
    //             style: TextStyle(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           // a flat button with a text label
    //           style: ButtonStyle(
    //               // style the button
    //               backgroundColor: MaterialStateProperty.all(
    //                   primaryOrange)), // set button background color
    //           onPressed: () {
    //             // method called when button is pressed
    //             Navigator.of(context).pushNamed(
    //               forgetPasswordRoute,
    //             );
    //           },
    //           child: const Text(
    //             // label text for the button
    //             "Forget Password",
    //             style: TextStyle(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           // a flat button with a text label
    //           style: ButtonStyle(
    //               // style the button
    //               backgroundColor: MaterialStateProperty.all(
    //                   primaryOrange)), // set button background color
    //           onPressed: () {
    //             // method called when button is pressed
    //             Navigator.of(context).pushNamed(
    //               verifyEmailRoute,
    //             );
    //           },
    //           child: const Text(
    //             // label text for the button
    //             "Login with unverified email!",
    //             style: TextStyle(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           // a flat button with a text label
    //           style: ButtonStyle(
    //               // style the button
    //               backgroundColor: MaterialStateProperty.all(
    //                   primaryOrange)), // set button background color
    //           onPressed: () {
    //             // method called when button is pressed
    //             Navigator.of(context).pushNamedAndRemoveUntil(
    //               // navigates to homeRoute screen and removes previous routes
    //               homeRoute,
    //               (route) => false,
    //             );
    //           },
    //           child: const Text(
    //             // label text for the button
    //             "Login with verified email!",
    //             style: TextStyle(
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],

    // ])
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Password",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Log in"),
          ),
        ],
      ),
    );
  }
}
