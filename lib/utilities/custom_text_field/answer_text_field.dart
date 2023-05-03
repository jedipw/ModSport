import 'package:flutter/material.dart';

import '../../constants/color.dart';

class AnswerTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isAnswerValid;
  const AnswerTextField({
    Key? key,
    required this.controller,
    required this.isAnswerValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 3),
          child: Row(
            children: const [
              Text(
                "Security Answer",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  height: 1.5,
                  color: primaryGray,
                ),
                textAlign: TextAlign.start,
              ),
            ],
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
            keyboardType: isAnswerValid ? TextInputType.name : null,
            style: const TextStyle(
              fontFamily: 'Poppins',
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (!isAnswerValid)
                const Text(
                  "Please enter your secure answer with at least 3 characters.",
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
