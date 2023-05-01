import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscure;
  final bool isEmailValid;
  final FocusNode? focusNode;
  
  const EmailTextField({
    Key? key,
    required this.controller,
    this.isObscure = false,
    required this.isEmailValid,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 3),
          child: Text(
            "Email",
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
            controller: controller,
            autofocus: true,
            keyboardType: isEmailValid ? TextInputType.emailAddress : null,
            obscureText: isObscure,
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
            decoration: const InputDecoration(
              hintText: "user12345@kmutt.ac.th" ,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            focusNode: focusNode,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (!isEmailValid)
                const Text(
                  "Please enter a valid email.",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
