import 'package:flutter/material.dart';

import '../../constants/color.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key? key,
    required this.passwordController,
    required this.isPasswordOk,
    this.text = 'Password',
  }) : super(key: key);

  final TextEditingController passwordController;
  final bool isPasswordOk;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 3),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 1.5,
              color: primaryGray,
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
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
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
              if (!isPasswordOk)
                const Text(
                  "Please enter the correct password.",
                  style: TextStyle(color: Colors.red, fontFamily: 'Poppins'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
