import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

typedef OnPressedCallBack = Function();

class EditButton extends StatelessWidget {
  final OnPressedCallBack onPressed;
  const EditButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'EDIT',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
              fontSize: 16,
              height: 1.5, // 39/26 = 1.5
              color: primaryGray,
            ),
          ),
          Icon(Icons.edit, color: primaryGray),
        ],
      ),
    );
  }
}
