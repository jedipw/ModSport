import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView(
      {super.key}); // constructor for LoginView, takes an optional key parameter

  @override
  _LoginViewState createState() => _LoginViewState();

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
      const SizedBox(height: 30),
      // LoginForm(),
    ]));
  }
}

// class LoginForm extends StatelessWidget {
//   static final _formKey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isEmailValid = true;

//   @override
//   void dispose() {
//     emailController.dispose();
//     // super.dispose();
//   }

//   LoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 32),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Email Input
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(15, 8, 8, 3),
//                 child: Text(
//                   'Email',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 17,
//                     height: 1.5,
//                     color: Color.fromRGBO(0, 0, 0, 0.6),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: const BorderRadius.all(Radius.circular(40)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.17),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   autofocus: true,
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   // validator: (value) {
//                   //   if (value == null || value.isEmpty) {
//                   //     return 'Please enter your email address';
//                   //   }
//                   //   if (!RegExp(
//                   //           r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$')
//                   //       .hasMatch(value)) {
//                   //     return 'Please enter a valid KMUTT email address';
//                   //   }
//                   //   return null;
//                   // },
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               // Password Input
//               const Padding(
//                 padding: EdgeInsets.fromLTRB(15, 8, 8, 3),
//                 child: Text(
//                   'Password',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 17,
//                     height: 1.5,
//                     color: Color.fromRGBO(0, 0, 0, 0.6),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(40)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.17),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: TextFormField(
//                   controller: passwordController,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                   obscureText: true,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       if (emailController.text == null ||
//                           emailController.text.isEmpty) {
//                         // return 'Please enter your email address';
//                       }
//                       if (!RegExp(
//                               r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$')
//                           .hasMatch(emailController.text)) {
//                         // return 'Please enter a valid KMUTT email address';
//                       }
//                     },
//                     style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(primaryOrange),
//                       shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(40))),
//                       fixedSize:
//                           MaterialStateProperty.all(const Size(173.42, 64)),
//                       side: MaterialStateProperty.all(BorderSide(
//                         color: primaryOrange,
//                         width: 2,
//                       )),
//                       overlayColor: MaterialStateProperty.all(Color.fromRGBO(
//                           0, 0, 0, 0.25)), // for the drop shadow effect
//                       elevation: MaterialStateProperty.all(
//                           4), // for the drop shadow effect
//                       shadowColor: MaterialStateProperty.all(
//                           Color.fromRGBO(0, 0, 0, 0.25)),
//                     ),
//                     child: Container(
//                       width: 173.42,
//                       height: 64,
//                       alignment: Alignment.center,
//                       child: const Text(
//                         "Log in",
//                         style: TextStyle(
//                           fontSize: 21,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ));
//   }
// }

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isEmailValid = true;
  bool _isPasswordOk = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 8, 3),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (!_isEmailValid)
                          const Text(
                            "Please enter a valid email",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  // Password form
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 8, 3),
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (!_isPasswordOk)
                          const Text(
                            "Please enter the correct password",
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Do something if the form is valid
                            // For example, check if the email is valid
                            if (_isValidEmail(emailController.text) &&
                                passwordController.value.text != "") {
                              // Navigate to next screen
                              setState(() {
                                _isEmailValid = true;
                                _isPasswordOk = true;
                              });
                              print(emailController.text + passwordController.text);
                            } else {
                              setState(() {
                                _isEmailValid = false;
                                _isPasswordOk = false;
                              });
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(primaryOrange),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                          fixedSize:
                              MaterialStateProperty.all(const Size(173.42, 64)),
                          side: MaterialStateProperty.all(BorderSide(
                            color: primaryOrange,
                            width: 2,
                          )),
                          overlayColor: MaterialStateProperty.all(Color.fromRGBO(
                              0, 0, 0, 0.25)), // for the drop shadow effect
                          elevation: MaterialStateProperty.all(
                              4), // for the drop shadow effect
                          shadowColor: MaterialStateProperty.all(
                              Color.fromRGBO(0, 0, 0, 0.25)),
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
    );
  }

  bool _isValidEmail(String email) {
    // Validate the email using a regular expression
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]" +
            r"{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]" +
            r"{0,61}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
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