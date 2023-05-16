import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/custom_text_field/email_text_field.dart';
import 'package:modsport/utilities/custom_text_field/fname_text_field.dart';
import 'package:modsport/utilities/custom_text_field/lname_text_field.dart';
import 'package:modsport/utilities/custom_text_field/reg_password_field.dart';
import 'package:modsport/utilities/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utilities/custom_text_field/reg_con_password_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  bool _isFnameValid = true;
  bool _isLnameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordOk = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Platform.isIOS
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.black, // set to Colors.black for black color
          ))
        : null;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 114, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          color: primaryOrange,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
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
            Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Column(
                  children: [
                    // Don't have verification yet
                    FnameTextField(
                        controller: firstNameController,
                        isFnameValid: _isFnameValid),
                    LnameTextField(
                        controller: lastNameController,
                        isLnameValid: _isLnameValid),
                    EmailTextField(
                        controller: emailController,
                        isEmailValid: _isEmailValid),
                    RegPasswordField(
                      passwordController: passwordController,
                      passwordStat: _isValidPassword(
                          passwordController.text.toString(),
                          confirmPasswordController.text.toString(),
                          "password"),
                      isPasswordOk: _isPasswordOk,
                    ),
                    RegConPasswordField(
                      passwordController: confirmPasswordController,
                      passwordStat: _isValidPassword(
                          confirmPasswordController.text.toString(),
                          passwordController.text.toString(),
                          "confirm password"),
                      isPasswordOk: _isPasswordOk,
                    ),
                    Center(
                      // centers child widget in the screen
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryOrange),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40))),
                          minimumSize:
                              MaterialStateProperty.all(const Size(130, 64)),
                        ),
                        onPressed: () async {
                          if (_isEverythingOk(
                              firstNameController.text.trim(),
                              lastNameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              confirmPasswordController.text.trim(),
                              questionController.text.trim(),
                              answerController.text.trim())) {
                            showAccountConfirmationModal(
                              context,
                              () async {
                                try {
                                  FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();
                                  Navigator.of(context).pop();
                                  showLoadModal(context);
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                                  userCredential.user?.updateDisplayName(
                                    "${firstNameController.text.trim().toUpperCase().substring(0, 1)}${firstNameController.text.trim().toLowerCase().substring(1)} ${lastNameController.text.trim().toUpperCase().substring(0, 1)}${lastNameController.text.trim().toLowerCase().substring(1)}",
                                  );
                                  await firestore
                                      .collection('user')
                                      .doc(userCredential.user!.uid)
                                      .set({
                                        'firstName': firstNameController.text
                                            .trim()
                                            .toLowerCase(),
                                        'lastName': lastNameController.text
                                            .trim()
                                            .toLowerCase(),
                                        'hasRole': false,
                                      })
                                      .then((value) {})
                                      .catchError((error) {})
                                      .then((value) =>
                                          Navigator.of(context).pop())
                                      .then((value) => Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                            // navigates to homeRoute screen and removes previous routes
                                            loginRoute,
                                            (route) => false,
                                          ));
                                } catch (e) {
                                  showErrorEmailModal(
                                    context,
                                    () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                              firstNameController.text
                                      .trim()
                                      .toUpperCase()
                                      .substring(0, 1) +
                                  firstNameController.text
                                      .trim()
                                      .toLowerCase()
                                      .substring(1),
                              lastNameController.text
                                      .trim()
                                      .toUpperCase()
                                      .substring(0, 1) +
                                  lastNameController.text
                                      .trim()
                                      .toLowerCase()
                                      .substring(1),
                              emailController.text,
                            );
                          }
                        },
                        child: const Text(
                          // label text for the button
                          "Sign up",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                            height: 1.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Have account text
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
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
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          // navigates to homeRoute screen and removes previous routes
                                          loginRoute,
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        "Sign in",
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
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      )),
    );
  }

  bool _isValidEmail(String email) {
    // Validate the email using a regular expression
    final emailRegex = RegExp(r'^[\w-\.]+@(kmutt\.ac\.th)$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z- ]+$');
    return (name != "" && name.length < 30 && nameRegex.hasMatch(name));
  }

  String _isValidPassword(String password1, String password2, String p) {
    if (password1 == "" || password1.isEmpty) {
      return 'Please enter your $p.';
    }
    if (password1.length < 6) {
      return 'Password should be at least 6 characters.';
    }
    if (password1 != password2) {
      return 'Passwords do not match.';
    }
    return "OK";
  }

  bool _isEverythingOk(String fName, String lName, String email,
      String password1, String password2, String question, String answer) {
    bool isOk = true;
    if (!_isValidName(fName)) {
      if (mounted) {
        setState(() {
          _isFnameValid = false;
        });
      }
      isOk = false;
    } else {
      if (mounted) {
        setState(() {
          _isFnameValid = true;
        });
      }
    }
    if (!_isValidName(lName)) {
      if (mounted) {
        setState(() {
          _isLnameValid = false;
        });
      }
      isOk = false;
    } else {
      if (mounted) {
        setState(() {
          _isLnameValid = true;
        });
      }
    }
    if (!_isValidEmail(email)) {
      if (mounted) {
        setState(() {
          _isEmailValid = false;
        });
      }
      isOk = false;
    } else {
      if (mounted) {
        setState(() {
          _isEmailValid = true;
        });
      }
    }
    if (_isValidPassword(password1, password2, "") != "OK") {
      if (mounted) {
        setState(() {
          _isPasswordOk = false;
        });
      }
      isOk = false;
    } else {
      if (mounted) {
        setState(() {
          _isPasswordOk = true;
        });
      }
    }
    return isOk;
  }
}

// Custom Modal
dynamic showAccountConfirmationModal(BuildContext context,
    OnPressedCallBack onPressed, String fName, String lName, String email) {
  showDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0.5),
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Do you want to use\n$fName $lName\nas your name and \n$email\nas email ?',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: primaryOrange,
                    height: 1.3,
                    letterSpacing: 0.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 84,
                      height: 43,
                      child: TextButton(
                        onPressed: onPressed,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryOrange,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            height: 1.2,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 34.0),
                    SizedBox(
                      width: 84,
                      height: 43,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            primaryGray,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            height: 1.2,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}
