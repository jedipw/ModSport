import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
// import 'package:modsport/firebase_options.dart';
import 'package:modsport/utilities/modal.dart';
// import 'package:dio/dio.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final User? user = FirebaseAuth.instance.currentUser;
  final bool _isEmailVerified = false;
  final FocusScopeNode _node = FocusScopeNode();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _checkUserEmailVerification();
    _node.unfocus();
  }

  Future<void> _checkUserEmailVerification() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already signed in
      if (_isEmailVerified) {
        await Navigator.of(context).pushNamedAndRemoveUntil(
          // navigates to homeRoute screen and removes previous routes
          homeRoute,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Text("Loading...");
    }
    // else if (_isEmailVerified) {
    //   log("User verified: ${user.emailVerified}");
    //   Future.delayed(Duration.zero, () async {
    //     await Navigator.of(context).pushNamedAndRemoveUntil(
    //       // navigates to homeRoute screen and removes previous routes
    //       homeRoute,
    //       (route) => false,
    //     );
    //   });
    //   return Container(color: Colors.white,child: const Text("Mail verified "),);
    // }
    else {
      return MaterialApp(
        navigatorKey: navigatorKey,
        home: FocusScope(
          node: _node,
          child: Scaffold(
              body:
                  // VerifyEmailViewComponent(),
                  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await signOut().then(
                      (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                            // navigates to homeRoute screen and removes previous routes
                            registerRoute,
                            (route) => false,
                          ));
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
                  const Text("We will send a verification email to"),
                  const SizedBox(height: 8),
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                  const SizedBox(height: 8),
                  const Text("Please check your email to verify"),
                  const SizedBox(height: 25),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryOrange),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        )),
                        minimumSize:
                            MaterialStateProperty.all(const Size(208, 60)),
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
                        try {
                          verifyEmail()
                              .then((_) => {Navigator.of(context).pop()})
                              // .then((value) => showSuccessMailModal)
                              // .then((value) async => await user!.reload())
                              .then((value) async => {await signOut()});

                          //.then((value) => {
                          //   if (user!.emailVerified)
                          //     {
                          //       setState(() {
                          //         _isEmailVerified = true;
                          //       })
                          //     }
                          // });
                          // .then((value) => showSuccessMailModal(context, true))
                          // .then(
                          //     (value) => Future.delayed(Duration.zero, () async {
                          //           await Navigator.of(context)
                          //               .pushNamedAndRemoveUntil(
                          //             // navigates to homeRoute screen and removes previous routes
                          //             loginRoute,
                          //             (route) => false,
                          //           );
                          //         }));
                        } on FirebaseAuthException catch (e) {
                          (_) => {Navigator.of(context).pop()};
                          log(e.toString());
                        }
                      },
                      child: const Text(
                        // "Resend email",
                        "Send email",
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
          )),
        ),
      );
    }
  }

  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (!(user!.emailVerified)) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => Future.delayed(Duration.zero, () async {
              await Navigator.of(context).pushNamedAndRemoveUntil(
                // navigates to login screen and removes previous routes
                loginRoute,
                (route) => false,
              );
            }));
  }
}

// class VerifyEmailViewComponent extends StatefulWidget {
//   const VerifyEmailViewComponent({super.key});

//   @override
//   State<VerifyEmailViewComponent> createState() =>
//       _VerifyEmailViewComponentState();
// }

// class _VerifyEmailViewComponentState extends State<VerifyEmailViewComponent> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.of(context).pushNamedAndRemoveUntil(
//               // navigates to homeRoute screen and removes previous routes
//               registerRoute,
//               (route) => false,
//             );
//           },
//           child: const Icon(Icons.arrow_back, color: primaryOrange),
//         ),
//         Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Verify your email address",
//               style: TextStyle(
//                 fontFamily: "Poppins",
//                 fontWeight: FontWeight.w600,
//                 fontSize: 21,
//                 height: 1.0,
//                 color: primaryOrange,
//               ),
//             ),
//             const SizedBox(height: 25),
//             const Text("We will send a verification email to"),
//             const SizedBox(height: 8),
//             Text(FirebaseAuth.instance.currentUser!.email.toString()),
//             const SizedBox(height: 8),
//             const Text("Please check your email to verify"),
//             const SizedBox(height: 25),
//             TextButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(primaryOrange),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   )),
//                   minimumSize: MaterialStateProperty.all(const Size(208, 60)),
//                   side: MaterialStateProperty.all(const BorderSide(
//                     color: primaryOrange,
//                   )),
//                   overlayColor:
//                       MaterialStateProperty.all(const Color(0x1FE17325)),
//                   shadowColor:
//                       MaterialStateProperty.all(const Color(0x3D000000)),
//                   elevation: MaterialStateProperty.all(4),
//                 ),
//                 // onPressed: () => (_) => Navigator.of(context).pushNamedAndRemoveUntil(
//                 //   // navigates to homeRoute screen and removes previous routes
//                 //   loginRoute,
//                 //   (route) => false,
//                 // ),
//                 onPressed: () async {
//                   final user = FirebaseAuth.instance.currentUser;
//                   log(user.toString());
//                   try {
//                     verifyEmail()
//                         .then((_) => {Navigator.of(context).pop()})
//                         .then((value) async => await user!.reload()).then((value) =>

//                                           setState(() {
//                                            _isEmailVerified = true;
//                                           })
//                                         );
//                     // .then((value) => showSuccessMailModal(context, true))
//                     // .then(
//                     //     (value) => Future.delayed(Duration.zero, () async {
//                     //           await Navigator.of(context)
//                     //               .pushNamedAndRemoveUntil(
//                     //             // navigates to homeRoute screen and removes previous routes
//                     //             loginRoute,
//                     //             (route) => false,
//                     //           );
//                     //         }));
//                   } on FirebaseAuthException catch (e) {
//                     (_) => {Navigator.of(context).pop()};
//                     log(e.toString());
//                   }
//                 },
//                 child: const Text(
//                   // "Resend email",
//                   "Resend email",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 22,
//                     height: 1,
//                     color: Colors.white,
//                   ),
//                 ))
//           ],
//         )),
//       ],
//     );
//   }

//   Future<void> verifyEmail() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (!(user!.emailVerified)) {
//       await user.sendEmailVerification();
//     }
//   }
// }

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
