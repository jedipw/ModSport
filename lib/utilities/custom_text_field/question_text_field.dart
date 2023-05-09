import 'package:flutter/material.dart';

import '../../constants/color.dart';

class QuestionTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isQuestionValid;
  const QuestionTextField({
    Key? key,
    required this.controller,
    required this.isQuestionValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 3),
          child: Row(
            children: const [
              Text(
                "Security Question",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  height: 1.5,
                  color: primaryGray,
                ),
                textAlign: TextAlign.start,
              ),
              Tooltip(
                message: 'In case you forget your password',
                preferBelow: false,
                child: Icon(Icons.info_outline,color: primaryGray,size: 18,),
              )
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
            keyboardType: isQuestionValid ? TextInputType.name : null,
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
              if (!isQuestionValid)
                const Text(
                  "Please enter your secure question with at least 10 characters.",
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
