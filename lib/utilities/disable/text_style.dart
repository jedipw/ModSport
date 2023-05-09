import 'package:flutter/material.dart';
import 'package:modsport/constants/color.dart';

TextStyle topTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 22,
  height:
      1.5, // or line-height: 33px, which is equivalent to 1.5 times the font size
  color: primaryGray,
);

TextStyle inputTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w400,
  fontSize: 22,
  height:
      1.5, // or line-height: 33px, which is equivalent to 1.5 times the font size
  color: Color.fromRGBO(0, 0, 0, 0.45),
);

TextStyle bottomTextStyle = const TextStyle(
  fontFamily: 'Poppins',
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  fontSize: 14,
  height:
      1.5, // or line-height: 21px, which is equivalent to 1.5 times the font size
  color: Color.fromRGBO(0, 0, 0, 0.45),
);
