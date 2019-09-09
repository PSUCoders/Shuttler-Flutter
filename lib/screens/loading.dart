import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:shuttler_flutter/models/user.dart';

import 'package:shuttler_flutter/utilities/config.dart';
import 'package:shuttler_flutter/utilities/dataset.dart';
import 'package:shuttler_flutter/utilities/secret.dart';
import 'package:shuttler_flutter/utilities/validator.dart';

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  bool isLogin;
  bool isDriver;
  bool _locationAcquired;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() async {
    /// Init data
    // Dataset.statusBarHeight.value = MediaQuery.of(context).padding.top;
    await _configureFirebaseApp();
    await _getUserData();
    await _requestedPermission();

    /// Route to another page
    if (isLogin) {
      if (isDriver) {
        // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => DriverHomeScreen()));
      } else {
        // Navigator.of(context).pushReplacement(
        //     CupertinoPageRoute(builder: (context) => HomeScreen()));
      }
    } else {
      // Navigator.of(context).pushReplacement(
      //     CupertinoPageRoute(builder: (context) => SignInScreen()));
    }
  }

  Future _requestedPermission() async {
    // Map<PermissionGroup, PermissionStatus> permissions =
    //     await PermissionHandler().requestPermissions([
    //   PermissionGroup.location,
    //   PermissionGroup.locationAlways,
    //   PermissionGroup.locationWhenInUse
    // ]);

    // PermissionStatus locationStatus = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.location);
    // PermissionStatus locationAlwaysStatus = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.locationAlways);
    // PermissionStatus locationWhenInUseStatus = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.locationWhenInUse);

    // if (locationStatus == null ||
    //     locationAlwaysStatus == null ||
    //     locationWhenInUseStatus == null) {
    //   _locationAcquired = false;
    // } else {
    //   _locationAcquired = true;
    // }
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
    print("User isLogin: $isLogin");

    if (isLogin) {
      isDriver = await isDriverAccount();
      print("isDriver: $isDriver");
      Dataset.isDriver.value = isDriver;
      if (!isDriver) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        final FirebaseDatabase database =
            FirebaseDatabase(app: Dataset.firebaseApp.value);

        FirebaseUser user = await auth.currentUser();
        DataSnapshot snapshot =
            await database.reference().child('Users/${user.uid}').once();
        Dataset.currentUser.value = User.fromSnapshot(snapshot);

        Dataset.token.value = await _firebaseMessaging.getToken();
      }
    } else {
      final FirebaseAuth auth = FirebaseAuth.instance;
      auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    Dataset.statusBarHeight.value = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.white,
    );
  }
}
