import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/utilities/custom_text_field/password_text_field.dart';
import 'package:modsport/utilities/drawer.dart';
// import 'package:path/path.dart';

import '../utilities/custom_text_field/reg_password_field.dart';
import '../utilities/modal.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final int _currentDrawerIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: ModSportDrawer(currentDrawerIndex: _currentDrawerIndex),
          body: Container(
            color: authenGray,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 75),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                          _scaffoldKey.currentState?.openEndDrawer();
                        } else {
                          _scaffoldKey.currentState?.openDrawer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: authenGray,
                        shape: const CircleBorder(),
                        fixedSize: const Size.fromRadius(25),
                        elevation: 0,
                      ),
                      child: const Icon(Icons.menu, color: primaryOrange),
                    ),
                  ],
                ),
                const Expanded(
                  child: CustomPageView(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Text("Loading..");
  }
}

class CustomPageView extends StatefulWidget {
  const CustomPageView({Key? key}) : super(key: key);

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  final _controller = PageController(initialPage: 0);
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String userId = "";
  bool _isCorrectPassword = true;
  bool _isPasswordValid = true;

  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser!;
  changePassword(String oldPassword, String newPassword) async {
    try {
      var cred = EmailAuthProvider.credential(
          email: currentUser.email!, password: oldPassword);
      await currentUser
          .reauthenticateWithCredential(cred)
          .then((value) => {currentUser.updatePassword(newPassword)})
          .then((value) => log("New password set! ${currentUser.toString()}"))
          .then((value) => {
                if (mounted)
                  {
                    setState(() {
                      _isCorrectPassword = true;
                      _confirmPasswordController = TextEditingController();
                      _newPasswordController = TextEditingController();
                      _currentPasswordController = TextEditingController();
                    })
                  }
              });
    } catch (error) {
      log(error.toString());
      if (mounted) {
        setState(() {
          _isCorrectPassword = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // First page
        SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
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
            child: Transform.rotate(
                angle: 320 * ((22 / 7) / 180),
                child: const Icon(
                  Icons.key_outlined,
                  size: 128,
                  color: Colors.white,
                )),
          ),
          const Text(
            'Change password',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 21,
              height: 1.5,
              color: primaryOrange,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 31, right: 31, bottom: 16),
            child: Text(
              'Enter your new password below',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                height: 1.5,
                color: Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: Column(
              children: [
                PasswordTextField(
                  passwordController: _currentPasswordController,
                  isPasswordOk: _isCorrectPassword,
                  text: "Current Password",
                ),
                RegPasswordField(
                    passwordController: _newPasswordController,
                    isPasswordOk: _isPasswordValid,
                    passwordStat: isValidPassword(
                        _newPasswordController.text.toString(),
                        _confirmPasswordController.text.toString(),
                        _currentPasswordController.text.toString(),
                        "password"),
                    text: "New Password"),
                RegPasswordField(
                    passwordController: _confirmPasswordController,
                    isPasswordOk: _isPasswordValid,
                    passwordStat: isValidPassword(
                        _confirmPasswordController.text.toString(),
                        _newPasswordController.text.toString(),
                        _currentPasswordController.text.toString(),
                        "confirm password"),
                    text: "Confirm Password"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryOrange),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
              minimumSize: MaterialStateProperty.all(const Size(173.42, 64)),
            ),
            onPressed: () {
              if (isValidPassword(
                      _newPasswordController.text.toString(),
                      _confirmPasswordController.text.toString(),
                      _currentPasswordController.text.toString(),
                      "P") ==
                  "OK") {
                log("New password OK");
                if (mounted) {
                  setState(() {
                    _isPasswordValid = true;
                  });
                  showSuccessPasswordModal(context, true);
                }
                if (_isCorrectPassword) {
                  changePassword(_currentPasswordController.text.toString(),
                      _confirmPasswordController.text.toString());
                }
              } else {
                if (mounted) {
                  setState(() {
                    _isPasswordValid = false;
                  });
                }
              }
            },
            child: const Text(
              "Save",
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String isValidPassword(
      String password1, String password2, String password3, String p) {
    if (password1 == "" || password1.isEmpty) {
      return 'Please enter your $p.';
    }
    if (password1.length < 6) {
      return 'Password should be at least 6 characters.';
    }
    if (password1 != password2) {
      return 'Passwords do not match.';
    }
    if (password1 == password3 || password1 == password3) {
      return 'The new password cannot be the same as the old password.';
    }
    return "OK";
  }
}
