import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:shuttler_ios/models/user.dart';

import 'package:shuttler_ios/screens/login/login.dart';
import 'package:shuttler_ios/screens/home/home.dart';
import 'package:shuttler_ios/utilities/dataset.dart';

const API_KEY = "AIzaSyAoih3-6DvYmtyJjS_o20yJkdJxbHJZ9KQ";

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db',
    options: (Platform.isIOS)
        ? const FirebaseOptions(
            googleAppID: '1:571374342123:android:caa2f6d813b8d2fc',
            gcmSenderID: '571374342123',
            databaseURL: 'https://shuttler-p001.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:571374342123:android:caa2f6d813b8d2fc',
            apiKey: 'AIzaSyAwrQEWxay6uhNfNIyLPsnh1w4dk6RF9ss',
            databaseURL: 'https://shuttler-p001.firebaseio.com',
          ),
  );

  Dataset.firebaseApp.value = app;

  var result = await checkIsLogin();
  if (result) {
    runApp(Shuttler(true));
  } else {
    runApp(Shuttler(false));
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

class Shuttler extends StatelessWidget {
  final Widget home;

  Shuttler(bool isLoggin) : home = (isLoggin ? HomeScreen() : SignInScreen()) {
    _getUserData();
  }

  void _getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();

    if (user != null) {
      final FirebaseDatabase database =
          FirebaseDatabase(app: Dataset.firebaseApp.value);

      DataSnapshot snapshot =
          await database.reference().child('Users/${user.uid}').once();
      final _firebaseMessaging = FirebaseMessaging();
      var token = await _firebaseMessaging.getToken();

      Map notiTokens = snapshot.value;
      if (!notiTokens.containsKey(token)) {
        DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child(
            'Users/${user.uid}/notifications/tokens/${Dataset.token.value}');
        tokenRef.set(true);
        snapshot = await FirebaseDatabase.instance
            .reference()
            .child('Users/${user.uid}')
            .once();
      }
      Dataset.currentUser.value = User.fromSnapshot(snapshot);
      Dataset.token.value = token;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Occasions',
      theme: ThemeData(
        primaryColor: Color(0xFFF2014B),
        textSelectionHandleColor: Color(0xFFF2014B),
      ),
      home: home,
    );
  }
}

// class NoSplashFactory extends InteractiveInkFeatureFactory {
//   const NoSplashFactory();

//   @override
//   InteractiveInkFeature create({
//     @required MaterialInkController controller,
//     @required RenderBox referenceBox,
//     @required Offset position,
//     @required Color color,
//     bool containedInkWell: false,
//     RectCallback rectCallback,
//     BorderRadius borderRadius,
//     double radius,
//     VoidCallback onRemoved,
//   }) {
//     return new NoSplash(
//       controller: controller,
//       referenceBox: referenceBox,
//     );
//   }
// }

// class NoSplash extends InteractiveInkFeature {
//   NoSplash({
//     @required MaterialInkController controller,
//     @required RenderBox referenceBox,
//   })  : assert(controller != null),
//         assert(referenceBox != null),
//         super(
//           controller: controller,
//           referenceBox: referenceBox,
//         );

//   @override
//   void paintFeature(Canvas canvas, Matrix4 transform) {}
// }
