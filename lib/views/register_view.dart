import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/customTextFeild/EmailTextField.dart';
import 'package:modsport/utilities/customTextFeild/FnameTextField.dart';
import 'package:modsport/utilities/customTextFeild/LnameTextField.dart';
import 'package:modsport/utilities/customTextFeild/PasswordTextField.dart';
import 'package:modsport/utilities/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modsport/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  _RegisterViewState createState() => _RegisterViewState();

  static final _formKey = GlobalKey<FormState>();
  static TextEditingController FnameController = TextEditingController();
  static TextEditingController LnameController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController confirmPasswordController =
      TextEditingController();

  // constructor for LoginView, takes an optional key parameter
  // const RegisterView({
  //   Key? key,
  // }) : super(key: key);

  // Confirm password validation method
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your confirm password';
    }
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
        // scaffold widget provides a basic app bar, drawer and body
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: primaryOrange,
        ), // app bar with a title
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //Name
                      TextFormField(
                        controller: FnameController,
                        decoration: const InputDecoration(labelText: "Name"),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^[a-zA-Z- ]+$').hasMatch(value)) {
                            return 'Please enter your name (only as a character and - allowed).';
                          }
                          return null;
                        },
                      ),
                      //Surname
                      TextFormField(
                        controller: LnameController,
                        decoration: const InputDecoration(labelText: "Surname"),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^[a-zA-Z- ]+$').hasMatch(value)) {
                            return 'Please enter your Surname (only as a character and - allowed).';
                          }
                          return null;
                        },
                      ),
                      //Email
                      // EmailTextField(controller: emailController,isEmailValid: true,),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: "Email",
                            hintText: "user12345@kmutt.ac.th"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(
                                  r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$')
                              .hasMatch(value)) {
                            return 'Please enter a valid KMUTT email address';
                          }
                          return null;
                        },
                      ),

                      //Password
                      TextFormField(
                        controller: passwordController,
                        decoration:
                            const InputDecoration(labelText: "Password"),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password should be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      //Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: const InputDecoration(
                            labelText: "Confirm Password"),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 25),
                      Center(
                        // centers child widget in the screen
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryOrange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            minimumSize: MaterialStateProperty.all(
                                const Size(173.42, 64)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
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
                                      "${FnameController.text.trim().toUpperCase().substring(0, 1)}${FnameController.text.trim().toLowerCase().substring(1)} ${LnameController.text.trim().toUpperCase().substring(0, 1)}${LnameController.text.trim().toLowerCase().substring(1)}",
                                    );
                                    await firestore
                                        .collection('user')
                                        .doc(userCredential.user!.uid)
                                        .set({
                                      'firstName': FnameController.text
                                          .trim()
                                          .toLowerCase(),
                                      'lastName': LnameController.text
                                          .trim()
                                          .toLowerCase(),
                                      'hasRole': false,
                                    }).then((value) {
                                      print('User added to Firestore');
                                    }).catchError((error) {
                                      print(
                                          'Error adding user to Firestore: $error');
                                    });
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed(
                                      //navigates to homeRoute screen and removes previous routes
                                      verifyEmailRoute,
                                    );
                                  } catch (e) {
                                    showErrorModal(
                                      context,
                                      () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                    // throw(e);
                                  }
                                },
                                FnameController.text
                                        .trim()
                                        .toUpperCase()
                                        .substring(0, 1) +
                                    FnameController.text
                                        .trim()
                                        .toLowerCase()
                                        .substring(1),
                                LnameController.text
                                        .trim()
                                        .toUpperCase()
                                        .substring(0, 1) +
                                    LnameController.text
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
                              fontSize: 24.0,
                              height: 1.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController FnameController = TextEditingController();
  final TextEditingController LnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isEmailValid = true;
  bool _isFnameValid = true;
  bool _isLnameValid = true;
  bool _isPassword1Ok = true;
  bool _isPassword2Ok = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 70, 0, 0),
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
            Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Column(
                  children: [
                    // Don't have verification yet
                    FnameTextField(
                        controller: FnameController,
                        isFnameValid: _isFnameValid),
                    LnameTextField(
                        controller: LnameController,
                        isLnameValid: _isLnameValid),
                    EmailTextField(
                        controller: emailController,
                        isEmailValid: _isEmailValid),
                    PasswordTextField(
                        passwordController: passwordController,
                        isPasswordOk: _isPassword1Ok),
                    PasswordTextField(
                        passwordController: confirmPasswordController,
                        isPasswordOk: _isPassword2Ok),

                    Column(
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
                                      Navigator.of(context).pushNamed(
                                        loginRoute,
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
                    )
                  ],
                )),
          ],
        ));
  }

  bool _isValidEmail(String email) {
    // Validate the email using a regular expression
    final emailRegex =
        RegExp(r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$');
    return emailRegex.hasMatch(email);
  }
}

// Custom Modal
dynamic showAccountConfirmationModal(BuildContext context,
    OnPressedCallBack onPressed, String Fname, String Lname, String email) {
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
                  'Do you want to use\n$Fname $Lname\nas your name and \n$email\nas email ?',
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: primaryRed,
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
                            primaryGreen,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
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
                            primaryRed,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
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

///////////////////// The nav part put in column/////////////////////
// child: Column(
//   children: [
//     //Name
//     const TextField(
//       decoration: InputDecoration(hintText: "Name"),
//     ),
//     //Surname
//     const TextField(
//       decoration: InputDecoration(hintText: "Surname"),
//     ),
//     //Email
//     TextField(
//       controller: emailController,
//       decoration:
//           const InputDecoration(hintText: "user12345@kmutt.ac.th"),
//       keyboardType: TextInputType.emailAddress,
//     ),

//     //Password
//     TextField(
//       controller: passwordController,
//       decoration: const InputDecoration(hintText: "Password"),
//       obscureText: true,
//       enableSuggestions: false,
//       autocorrect: false,
//     ),
//     //Confirm Password
//     TextField(
//       controller: passwordController,
//       decoration: const InputDecoration(hintText: "Confirm Password"),
//       obscureText: true,
//       enableSuggestions: false,
//       autocorrect: false,
//     ),
//     const SizedBox(height: 25),
//     Center(
//       // centers child widget in the screen
//       child: TextButton(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(primaryOrange),
//           shape: MaterialStateProperty.all(RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(40))),
//           minimumSize:
//               MaterialStateProperty.all(const Size(173.42, 64)),
//         ),
//         onPressed: () async {
//           await Firebase.initializeApp(
//               options: DefaultFirebaseOptions.currentPlatform
//           );

//           final email = emailController.text;
//           final password = passwordController.text;
//           final userCredential = await FirebaseAuth.instance
//               .createUserWithEmailAndPassword(
//                   email: email, password: password);
//           print(userCredential);
//         },
//         child: const Text(
//           // label text for the button
//           "Sign up",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 24.0,
//             height: 1.0,
//             color: Colors.white,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     ),
//     //Nav to verify page
//     // TextButton(
//     //   // a flat button with a text label
//     //   style: ButtonStyle(
//     //       // style the button
//     //       backgroundColor: MaterialStateProperty.all(
//     //           primaryOrange)), // set button background color
//     //   onPressed: () {
//     //     // method called when button is pressed
//     //     Navigator.of(context).pushNamed(
//     //       // navigates to homeRoute screen and removes previous routes
//     //       verifyEmailRoute,
//     //     );
//     //   },
//     //   child: const Text(
//     //     // label text for the button
//     //     "Register!",
//     //     style: TextStyle(
//     //       color: Colors.white,
//     //     ),
//     //   ),
//     // ),
//   ],
// ),