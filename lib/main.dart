import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shuttler_ios/screens/login/login.dart';
import 'package:shuttler_ios/utilities/config.dart';
import 'package:shuttler_ios/screens/home/home.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db',
    options: (Platform.isIOS)
      ? const FirebaseOptions(
          googleAppID: '1:571374342123:ios:caa2f6d813b8d2fc',
          gcmSenderID: '571374342123',
          databaseURL: 'https://shuttler-p001.firebaseio.com',
        )
      : const FirebaseOptions(
          googleAppID: '1:571374342123:android:caa2f6d813b8d2fc',
          apiKey: 'AIzaSyAwrQEWxay6uhNfNIyLPsnh1w4dk6RF9ss',
          databaseURL: 'https://shuttler-p001.firebaseio.com',
        ),
  );

  var result = await checkIsLogin();
  if(result){
    runApp(Shuttler(true, app));
  }
  else {
    runApp(Shuttler(false, app));
  }
}

Future<bool> checkIsLogin() async {
    return await getIsLogin();
  }

class Shuttler extends StatelessWidget {
  final Widget home;
  final FirebaseApp app;

  Shuttler(bool isLoggin, this.app) : home = (isLoggin ? HomeScreen() : SignInScreen());

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Occasions',
      theme: ThemeData(primaryColor: Color(0xFFF2014B),textSelectionHandleColor:  Color(0xFFF2014B)),
      home: home,
    );
  }

}

