import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/modal.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final User? user = FirebaseAuth.instance.currentUser;
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
      if (user.emailVerified) {
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
    Platform.isIOS
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.black, // set to Colors.black for black color
          ))
        : null;
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Text("Loading...");
    } else {
      return MaterialApp(
        navigatorKey: navigatorKey,
        home: FocusScope(
          node: _node,
          child: Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 59, 0, 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await signOut().then((value) =>
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                // navigates to homeRoute screen and removes previous routes
                                registerRoute,
                                (route) => false,
                              ));
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: primaryOrange,
                          size: 38,
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                    child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.only(
                          bottom: 32,
                        ),
                        decoration: const BoxDecoration(
                          color: primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mail,
                          size: 128,
                          color: Colors.white,
                        ),
                      ),
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
                      const Text("You’ve entered",style: TextStyle(fontSize: 16),),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${FirebaseAuth.instance.currentUser!.email}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                          const Text(" as the",style: TextStyle(fontSize: 16),)
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("email address for your account.",style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text("Please verity this email",style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text("address by pressing button below.",style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 25),
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryOrange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            )),
                            minimumSize:
                                MaterialStateProperty.all(const Size(300, 60)),
                            side: MaterialStateProperty.all(const BorderSide(
                              color: primaryOrange,
                            )),
                            overlayColor: MaterialStateProperty.all(
                                const Color(0x1FE17325)),
                            shadowColor: MaterialStateProperty.all(
                                const Color(0x3D000000)),
                            elevation: MaterialStateProperty.all(4),
                          ),
                          onPressed: () async {
                            try {
                              verifyEmail().then((value) =>
                                  showSuccessMailModal(context, true));
                            } on FirebaseAuthException catch (_) {
                              (_) => {Navigator.of(context).pop()};
                            }
                          },
                          child: const Text(
                            "Send email verification",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                              height: 1,
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),
                )),
              ],
            ),
          ),
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
