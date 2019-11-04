import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// textTheme
///
/// headline: title of a section
/// display1: dates
class ShuttlerTheme {
  static ThemeData of(BuildContext context) {
    return Theme.of(context).copyWith(
      // backgroundColor: Colors.white,
      primaryColor: Colors.pink,
      accentColor: Colors.pink,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16, color: Colors.pink),
        hintStyle: TextStyle(fontSize: 16, color: Colors.pink),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.pink,
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
            headline: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            // Used for displaying dates
            display1: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
      cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: Colors.white12,
        brightness: Brightness.light,
        primaryColor: Colors.pink,
        primaryContrastingColor: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
          color: Colors.black87,
        )),
      ),
    );
  }
}
