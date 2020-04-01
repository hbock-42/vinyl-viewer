import 'package:flutter/material.dart';

class AppTheme {
  static const Color red = const Color.fromRGBO(246, 88, 106, 1);
  static const Color blue = const Color.fromRGBO(120, 148, 196, 1);
  static const Color whiteFake = const Color.fromRGBO(245, 247, 252, 1);
  static final BorderRadius borderRadius = BorderRadius.circular(6);

  static TextTheme whiteText = TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.w600,
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 24,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ),
    headline4: TextStyle(
      color: Colors.white,
      fontSize: 22,
    ),
    bodyText1: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    overline: TextStyle(color: Colors.green),
    button: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );

  static TextTheme blueText = TextTheme(
    headline1: TextStyle(
      color: Color.fromRGBO(82, 92, 142, 1.0),
      fontSize: 40,
      fontWeight: FontWeight.w600,
    ),
    headline2: TextStyle(
      color: Color.fromRGBO(82, 92, 152, 0.8),
      fontSize: 24,
    ),
    headline3: TextStyle(
      color: Color.fromRGBO(82, 92, 152, 0.5),
      fontSize: 22,
    ),
    headline4: TextStyle(color: Colors.green),
    bodyText1: TextStyle(
      color: blue,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      color: blue,
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    overline: TextStyle(color: Colors.green),
    button: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );
}
