import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';
import 'package:modsport/constants/routes.dart';
import 'package:modsport/utilities/custom_text_field/email_text_field.dart';

import '../utilities/custom_button/next_button.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({Key? key})
      : super(
            key:
                key); // constructor for LoginView, takes an optional key parameter

  @override
  Widget build(BuildContext context) {
    // required method to build the UI
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 59, 0, 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    // navigates to homeRoute screen and removes previous routes
                    loginRoute,
                    (route) => false,
                  );
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
        const Expanded(
          child: CustomPageView(),
        ),
      ]),
    );
  }
}

class CustomPageView extends StatefulWidget {
  const CustomPageView({Key? key}) : super(key: key);

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  final _controller = PageController(initialPage: 0);
  final TextEditingController emailController = TextEditingController();
  bool _isEmailValid = true;

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      children: [
        // First page
        SingleChildScrollView(
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
                  Icons.lock,
                  size: 128,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Forgot password?',
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
                padding:
                    EdgeInsets.only(left: 31, right: 31, top: 16, bottom: 16),
                child: Text(
                  'Enter the email address associated with your account. We will send you an email to change your password.',
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
                child: EmailTextField(
                    controller: emailController, isEmailValid: _isEmailValid),
              ),
              const SizedBox(height: 32),
              CustomPageViewButton(
                pageIndex: 1,
                controller: _controller,
                onPressed: () {
                  nextPage();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),

        // Second page
        Container(
          color: Colors.red,
          child: Center(
            child:
                // ElevatedButton(
                //   onPressed: () {
                //     _controller.animateToPage(
                //       0,
                //       duration: const Duration(milliseconds: 500),
                //       curve: Curves.ease,
                //     );
                //   },
                //   child: const Text("Back"),
                // ),
                CustomPageViewButton(
              pageIndex: 0,
              controller: _controller,
            ),
          ),
        )
      ],
    );
  }

  bool _isValidEmail(String email) {
    // Validate the email using a regular expression
    final emailRegex =
        RegExp(r'^[\w-\.]+@(kmutt\.ac\.th|mail\.kmutt\.ac\.th)$');
    return emailRegex.hasMatch(email);
  }

  void nextPage() {
    if (_isValidEmail(emailController.text)) {
      if (mounted) {
        setState(() {
          _isEmailValid = true;
        });
      }
      _controller.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      if (mounted) {
        setState(() {
          _isEmailValid = false;
        });
      }
    }
  }
}
