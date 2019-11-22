import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/sign_in/email_verification_screen.dart';
import 'package:shuttler/screens/sign_in/sign_in_layout.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/validator.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _fieldFocusNode = FocusNode();

  Future<void> _handleSendEmail() async {
    final AuthState authState = Provider.of<AuthState>(context, listen: false);

    final emailSent =
        await authState.sendSignInWithEmailLink(_controller.text.trim());

    if (!emailSent) {
      Flushbar(
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.red[400],
        ),
        message: "Unable to send sign in email",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
      )..show(context);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
    );
  }

  /// Handle the event of finishing typing the email
  void _handleEmailSubmit([String text]) {
    _fieldFocusNode.unfocus(); // Close the keyboard

    final noError = _formKey.currentState.validate();

    if (noError) {
      print('no error');
      _handleSendEmail();
    }
  }

  String _validateEmail(String email) {
    if (Validator.isPlattsburghEmail(email)) return null;

    return ErrorMessages.wrongEmail;
  }

  @override
  Widget build(BuildContext context) {
    return SignInLayout(
      onEmailSubmitted: _handleEmailSubmit,
      emailValidator: _validateEmail,
      focusNode: _fieldFocusNode,
      controller: _controller,
      onActionButtonPress: _handleEmailSubmit,
      formKey: _formKey,
    );
  }
}
