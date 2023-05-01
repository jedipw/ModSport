import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/customTextFeild/FemailTextField.dart';
import 'package:modsport/utilities/customTextFeild/PasswordTextField.dart';

import '../utilities/modal.dart';

class LoginView extends StatefulWidget {
  const LoginView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isEmailValid = true;
  bool _isPasswordOk = true;
  bool _isSomeThingWrong = false;
  bool isKeyboardVisible = false;
  FocusNode emailFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email form
                        EmailTextField(
                          controller: emailController,
                          isEmailValid: _isEmailValid,
                          focusNode: emailFocusNode,
                        ),
                        // Password form
                        PasswordTextField(
                            passwordController: passwordController,
                            isPasswordOk: _isPasswordOk),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (_isSomeThingWrong)
                                const Text(
                                  "Please make sure that you log in with the correct email and password",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    forgetPasswordRoute,
                                  );
                                },
                                child: const Text(
                                  "Forget password?",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 1.0,
                                    decoration: TextDecoration.underline,
                                    color: Color(0xFFCC0019),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                final email = emailController.text;
                                final password = passwordController.text;
                                if (_formKey.currentState!.validate()) {
                                  // Do something if the form is valid
                                  // For example, check if the email is valid
                                  if (_isValidEmail(emailController.text) &&
                                      passwordController.value.text.length >=
                                          6) {
                                    setState(() {
                                      _isEmailValid = true;
                                      _isPasswordOk = true;
                                      _isSomeThingWrong = false;
                                    });
                                    try {
                                      showLoadModal(context);
                                      try {
                                        final userCredential =
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: email,
                                                    password: password);
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();

                                        if (userCredential
                                                .user?.emailVerified ??
                                            false) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            // navigates to homeRoute screen and removes previous routes
                                            homeRoute,
                                            (route) => false,
                                          );
                                        } else {
                                          /////////////////////////////////////////////// CHANGE NAV NOT VERIFY MAIL HERE ///////////////////////////////////////////////
                                          // ignore: use_build_context_synchronously
                                          // Navigator.of(context).pushNamed(
                                          //   verifyEmailRoute,
                                          // );
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            // navigates to homeRoute screen and removes previous routes
                                            homeRoute,
                                            (route) => false,
                                          );
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        setState(() {
                                          _isSomeThingWrong = true;
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        _isSomeThingWrong = true;
                                      });
                                      if (e.code == 'user-not-found') {
                                        print('User not found');
                                      } else {
                                        print('SOMETHING ELSE HAPPEND');
                                        print(e.code);
                                      }
                                    }
                                  } else {
                                    if (emailController.text == "" ||
                                        !_isValidEmail(emailController.text)) {
                                      setState(() {
                                        _isEmailValid = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isEmailValid = true;
                                      });
                                    }
                                    if (passwordController.value.text.length <
                                        6) {
                                      setState(() {
                                        _isPasswordOk = false;
                                      });
                                    } else {
                                      setState(() {
                                        _isPasswordOk = true;
                                      });
                                    }
                                    if (_isPasswordOk && _isEmailValid) {
                                      setState(() {
                                        _isSomeThingWrong = true;
                                      });
                                    }
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primaryOrange),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40))),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(173.42, 64)),
                                side:
                                    MaterialStateProperty.all(const BorderSide(
                                  color: primaryOrange,
                                  width: 2,
                                )),
                                overlayColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(0, 0, 0,
                                        0.25)), // for the drop shadow effect
                                elevation: MaterialStateProperty.all(
                                    4), // for the drop shadow effect
                                shadowColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(0, 0, 0, 0.25)),
                              ),
                              child: Container(
                                width: 173.42,
                                height: 64,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              // left: ,
              bottom: isKeyboardVisible ? 0 : 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(90, 0, 16, 16),
                child:
                    //  Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    Row(
                  // mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 1.5,
                        color: Color.fromRGBO(0, 0, 0, 0.45),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                registerRoute,
                              );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.0,
                                decoration: TextDecoration.underline,
                                color: primaryOrange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //   ],
                // )
              ))
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Validate the email using a regular expression
    final emailRegex =
        RegExp(r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$');
    return emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    // add listener to track keyboard visibility
    WidgetsBinding.instance.addObserver(
      KeyboardVisibilityObserver((bool visible) {
        setState(() {
          isKeyboardVisible = visible;
        });
      }),
    );
  }
}

// a class to observe keyboard visibility changes
class KeyboardVisibilityObserver extends WidgetsBindingObserver {
  final Function(bool) onVisibilityChanged;

  KeyboardVisibilityObserver(this.onVisibilityChanged);

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // determine keyboard visibility based on height
    final bool visible = WidgetsBinding.instance!.window.viewInsets.bottom > 0;
    onVisibilityChanged(visible);
  }
}

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