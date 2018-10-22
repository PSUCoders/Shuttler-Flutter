import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:shuttler_ios/screens/home/home.dart';

String message = 
"""
We've sent you a comfirmation code to your email.
Please follow the instruction from your email to verify your account.
Make sure to check your Spam box if you don't receive the email.
""";

Color activeColor = Color(0xffF2014B);
Color disableColor = Color(0xfffb83a7);

class VerifyAccountScreen extends StatefulWidget {
  // final User user;
  final FirebaseUser user;
  VerifyAccountScreen(this.user);

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  bool hasVerified;
  Timer _verificationTimer;
  
  @override
  initState() {
    super.initState();
    hasVerified = false;
    _verificationTimer = null;
    verifying();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void _handleTimer() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    await user.reload();
    if(user.isEmailVerified) {
      setState(() {
        hasVerified = true;
        _verificationTimer = null;
      });
    }
    else {
      _verificationTimer = Timer(Duration(seconds: 2), _handleTimer);
    }
  }

  void verifying() async {
    widget.user.sendEmailVerification();
    
    if(_verificationTimer == null) {
      _verificationTimer = Timer(Duration(seconds: 2), _handleTimer);
    }
  }

  void verifyDone() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => HomeScreen()),);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150.0,),
            Text(message + widget.user.email, style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 50.0,),
            CupertinoButton(
              disabledColor: disableColor,
              color: activeColor,
              onPressed: hasVerified ? verifyDone : null ,
              child: Text("DONE"),
            ),
          ]
        ),
      )
    );
  }

  
}
