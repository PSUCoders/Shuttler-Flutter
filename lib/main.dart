import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shuttler_ios/screens/login/login.dart';
import 'package:shuttler_ios/utilities/config.dart';
import 'package:shuttler_ios/screens/home/home.dart';

void main() async {
  var result = await checkIsLogin();
  if(result){
    runApp(Shuttler(true));
  }
  else {
    runApp(Shuttler(false));
  }
}

Future<bool> checkIsLogin() async {
    return await getIsLogin();
  }

class Shuttler extends StatelessWidget {
  final Widget home;
  Shuttler(bool isLoggin) : home = (isLoggin ? HomeScreen() : LoginWithEmailScreen());

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Your Occasions',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
    );
  }

}

