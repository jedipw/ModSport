import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/firebase_options.dart';
import 'package:modsport/services/cloud/cloud_storage_constants.dart';
import 'package:modsport/utilities/modal.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      // scaffold widget provides a basic app bar, drawer and body
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: primaryOrange,
      ), // app bar with a title
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                print(user);
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
    return Center(
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
        Text(FirebaseAuth.instance.currentUser!.email.toString()),
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
              overlayColor: MaterialStateProperty.all(const Color(0x1FE17325)),
              shadowColor: MaterialStateProperty.all(const Color(0x3D000000)),
              elevation: MaterialStateProperty.all(4),
            ),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              showLoadModal(context);
              await user?.sendEmailVerification();
              Navigator.of(context).pop();
            },
            child: const Text(
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
    ));
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