import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShuttlerTheme {
  static ThemeData of(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.pink,
      accentColor: Colors.pink,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16, color: Colors.pink),
        hintStyle: TextStyle(fontSize: 16, color: Colors.pink),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: Colors.white12,
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        // primaryContrastingColor: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(),
        ),
      ),
    );
  }
}
