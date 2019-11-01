import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/sign_in/sign_in_cupertino.dart';
import 'dart:io' show Platform;

import 'package:shuttler/screens/sign_in/sign_in_material.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
// with WidgetsBindingObserver {
{
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     print('AppLifecycleState.resumed');
  //     // _retrieveDynamicLink();
  //   }
  // }

  Future<bool> _sendSignInWithEmailLink(AuthState state, String email) async {
    try {
      state.sendSignInWithEmailLink(email.trim());
    } catch (e) {
      print("Error sending email link $e");
      // _showDialog(e.toString());
      return false;
    }

    print(email + "<< sent");
    return true;
  }

  handleSendEmailLink(
    String email,
    AuthState authState,
  ) {
    print('email to send link: $email');

    // _sendSignInWithEmailLink(authState, "hnguy011@plattsburgh.edu");
    _sendSignInWithEmailLink(authState, email);
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = Provider.of<AuthState>(context);

    if (Platform.isAndroid) {
      return SignInMaterial(
        onSendEmailPress: (email) => handleSendEmailLink(email, authState),
      );
    } else {
      return SignInCupertino(
        onSendEmailPress: (email) => handleSendEmailLink(email, authState),
      );
    }
  }
}
