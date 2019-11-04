import 'package:flutter/material.dart';
import 'package:shuttler/utilities/contants.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            kVerificationScreenMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
