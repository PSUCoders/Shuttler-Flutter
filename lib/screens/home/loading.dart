import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shuttler_ios/models/user.dart';
import 'package:shuttler_ios/screens/home/driver_home.dart';

import 'package:shuttler_ios/screens/login/login.dart';
import 'package:shuttler_ios/screens/home/home.dart';
import 'package:shuttler_ios/utilities/config.dart';
import 'package:shuttler_ios/utilities/dataset.dart';
import 'package:shuttler_ios/utilities/secret.dart';
import 'package:shuttler_ios/utilities/validator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  bool isLogin;
  bool isDriver;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() async {
    /// Init data
    Dataset.statusBarHeight.value = await FlutterStatusbarManager.getHeight;
    await _configureFirebaseApp();
    await _getUserData();

    /// Route to another page
    if (isLogin) {
      if (isDriver) {
        // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => DriverHomeScreen()));
      }
      else {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => HomeScreen()));
      }
    }
    else {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => SignInScreen()));
    }
  }

  Future _configureFirebaseApp() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'db',
      options: (Platform.isIOS)
        ? const FirebaseOptions(
            googleAppID: GOOGLE_APP_ID,
            gcmSenderID: GCM_SENDER_ID,
            databaseURL: DATABASE_URL,
          )
        : const FirebaseOptions(
            googleAppID: GOOGLE_APP_ID,
            apiKey: FIREBASE_API_KEY,
            databaseURL: DATABASE_URL,
          ),
    );
    Dataset.firebaseApp.value = app;
  }

  Future _getUserData() async {
    /// Check whether user is login.
    isLogin = await getIsLogin();

    if (isLogin) {
      isDriver = await isDriverAccount();
      Dataset.isDriver.value = isDriver;
      if (!isDriver) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        final FirebaseDatabase database = FirebaseDatabase(app: Dataset.firebaseApp.value);

        FirebaseUser user = await auth.currentUser();
        DataSnapshot snapshot = await database.reference().child('Users/${user.uid}').once();
        Dataset.currentUser.value = User.fromSnapshot(snapshot);

        Dataset.token.value = await _firebaseMessaging.getToken();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
