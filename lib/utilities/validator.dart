import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

RegExp username = RegExp(r"\b[A-Za-z]{5}[0-9]{3}\b");
RegExp EMAIL_REGEXP = RegExp(r"\b[a-z]{5}[0-9]{3}\@plattsburgh.edu\b");
RegExp PASSWORD_REGEXP = RegExp(r"\b[A-Za-z0-9]\!\@\#\$\%\^\&\*\~\(\)\\\b");

bool isDate(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

bool isPassword(String pw) {
  return pw.length >= 6 && pw.length <= 30;
}

bool isEmail(String email) {
  RegExp _email = new RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  return _email.hasMatch(email);
}

bool isName(String name) {
  RegExp _alpha = new RegExp(r'^[a-zA-Z]+$');

  return _alpha.hasMatch(name);
}

bool isPlattsburghEmail(String login) {
  // if (login.length == 8) {
  //   return username.hasMatch(login.toLowerCase());
  // }
  return EMAIL_REGEXP.hasMatch(login.toLowerCase());
}

bool isStudentID(String login) {
  // print(username.hasMatch(login));
  if (login.length != 8) return false;
  return username.hasMatch(login);
}

Future<bool> isDriverAccount() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser = await auth.currentUser();

  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child('Drivers/${currentUser.uid}')
      .once();
  if (snapshot.value == null) {
    return false;
  } else {
    return true;
  }
}

Future<bool> checkIsLogin() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  if (user?.email != null) {
    return true;
  } else {
    return false;
  }
}

String emailValidator(String email) => !isPlattsburghEmail(email)
    ? 'Please provide correct SUNY Plattsburgh email'
    : null;

String passwordValidator(String password) =>
    // TODO better error message
    !isPassword(password) ? 'Please provide correct password' : null;
