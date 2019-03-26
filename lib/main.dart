import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shuttler_flutter/screens/home/loading.dart';

void main() => runApp(ShuttlerApp());

Future<bool> checkIsLogin() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user = await auth.currentUser();
  if (user?.email != null) {
    return true;
  } else {
    return false;
  }
}

class ShuttlerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Your Occasions',
        theme: ThemeData(
          primaryColor: Color(0xFFF2014B),
          textSelectionHandleColor: Color(0xFFF2014B),
        ),
        home: LoadingScreen());
  }
}
