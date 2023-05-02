import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/firebase_options.dart';
import 'package:modsport/utilities/modal.dart';
// import 'package:dio/dio.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      backgroundColor: loginGray,
      // scaffold widget provides a basic app bar, drawer and body
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                log(user.toString());
                if (user?.emailVerified ?? false) {
                  return const Text("You are a verified user.");
                } else {
                  return const VerifyEmailViewComponent();
                }
              default:
                return const Text("Loading...");
            }
          }),
    );
  }
}

class VerifyEmailViewComponent extends StatefulWidget {
  const VerifyEmailViewComponent({super.key});

  @override
  State<VerifyEmailViewComponent> createState() =>
      _VerifyEmailViewComponentState();
}

class _VerifyEmailViewComponentState extends State<VerifyEmailViewComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              // navigates to homeRoute screen and removes previous routes
              registerRoute,
              (route) => false,
            );
          },
          child: const Icon(Icons.arrow_back, color: primaryOrange),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verify your email address",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 21,
                height: 1.0,
                color: primaryOrange,
              ),
            ),
            const SizedBox(height: 25),
            const Text("We have sent a verification email to"),
            const SizedBox(height: 8),
            Text(FirebaseAuth.instance.currentUser!.email.toString()),
            const SizedBox(height: 8),
            const Text("Please check your email to verify"),
            const SizedBox(height: 25),
            TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryOrange),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  )),
                  minimumSize: MaterialStateProperty.all(const Size(208, 60)),
                  side: MaterialStateProperty.all(const BorderSide(
                    color: primaryOrange,
                  )),
                  overlayColor:
                      MaterialStateProperty.all(const Color(0x1FE17325)),
                  shadowColor:
                      MaterialStateProperty.all(const Color(0x3D000000)),
                  elevation: MaterialStateProperty.all(4),
                ),
                // onPressed: () => (_) => Navigator.of(context).pushNamedAndRemoveUntil(
                //   // navigates to homeRoute screen and removes previous routes
                //   loginRoute,
                //   (route) => false,
                // ),
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  log(user.toString());
                  showLoadModal(context);
                  // await Dio().get(
                  //   'https://firebase.google.com',
                  //   options: Options(headers: {'X-Firebase-Locale': 'th'}),
                  // );
                  try {
                    verifyEmail().then((_) => {Navigator.of(context).pop()});
                  } on FirebaseAuthException catch (e) {
                    (_) => {Navigator.of(context).pop()};
                    log(e.toString());
                  }
                },
                child: const Text(
                  // "Resend email",
                  "Resend email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    height: 1,
                    color: Colors.white,
                  ),
                ))
          ],
        )),
      ],
    );
  }

  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (!(user!.emailVerified)) {
      await user.sendEmailVerification();
    }
  }
}

///////////////////// The nav part /////////////////////
// Center(
//         // centers child widget in the screen
//         child: TextButton(
//           // a flat button with a text label
//           style: ButtonStyle(
//               // style the button
//               backgroundColor: MaterialStateProperty.all(
//                   primaryOrange)), // set button background color
//           onPressed: () {
//             // method called when button is pressed
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               // navigates to homeRoute screen and removes previous routes
//               loginRoute,
//               (route) => false,
//             );
//           },
//           child: const Text(
//             // label text for the button
//             "Login!",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),