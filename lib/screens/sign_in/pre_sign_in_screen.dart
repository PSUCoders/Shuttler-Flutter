import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/sign_in/sign_in_screen.dart';
import 'package:shuttler/widgets/shuttler_logo.dart';

Future<bool> checkIfAuthenticated() async {
  await Future.delayed(Duration(
      seconds: 5)); // could be a long running task, like a fetch from keychain
  return true;
}

class PreSignInScreen extends StatefulWidget {
  const PreSignInScreen({Key key}) : super(key: key);

  @override
  _PreSignInScreenState createState() => _PreSignInScreenState();
}

class _PreSignInScreenState extends State<PreSignInScreen> {
  StreamSubscription<FirebaseUser> _authSubscription;

  @override
  void initState() {
    super.initState();

    // Listen to auth status
    _authSubscription = Provider.of<AuthState>(context, listen: false)
        .authStream()
        .listen((user) {
      if (user != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/home', ModalRoute.withName('/home'));
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.maxFinite,
              color: Colors.pink,
              child: Center(
                child: ShuttlerLogo(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Get started with Shuttler",
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your email",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
