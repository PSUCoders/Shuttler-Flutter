import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/sign_in/sign_in_driver_screen.dart';
import 'package:shuttler/screens/sign_in/sign_in_screen.dart';
import 'package:shuttler/widgets/shuttler_logo.dart';

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
        .listen(_handleAuthChange);
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  void _handleAuthChange(FirebaseUser user) {
    if (user != null && user.isAnonymous) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/home'));
    }
  }

  void _handleGetStartedTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  void _handleDriverTap() {
    // TODO
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInDriverScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  color: Colors.pink,
                  child: Center(
                    child: ShuttlerLogo(),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                    color: Colors.grey[800],
                    onPressed: _handleDriverTap,
                    child: Text('I am a driver'),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: _handleGetStartedTap,
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
