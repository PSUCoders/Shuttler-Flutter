import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _showPasswordField = false;

  Future<void> _signInAsTester() async {
    final AuthState authState = Provider.of<AuthState>(context, listen: false);

    final result = await authState.signInWithEmailPassword(
        _controller.text, _passwordController.text);
    if (result != null) {
      print('sign in as tester successfully');
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      // TODO handle this
    }
  }

  Future<void> _sendEmailLink() async {
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

    if (_controller.text == DotEnv().env[ENV.testerEmail]) {
      //
      print('showing the password field');
      setState(() {
        _showPasswordField = true;
      });
    } else {
      final noError = _formKey.currentState.validate();

      if (noError) {
        print('no error');
        _sendEmailLink();
      }
    }
  }

  /// Handle the event of finishing typing the email
  void _handlePasswordSubmit([String text]) {
    _passwordFocusNode.unfocus(); // Close the keyboard

    final noError = _formKey.currentState.validate();
    print(noError);

    if (noError) {
      print('no error');
      _signInAsTester();
    }
  }

  String _validateEmail(String email) {
    if (email == DotEnv().env[ENV.testerEmail]) return null;

    if (Validator.isPlattsburghEmail(email)) return null;

    return ErrorMessages.wrongEmail;
  }

  String _validatePassword(String password) {
    if (Validator.isPassword(password)) return null;

    return ErrorMessages.wrongPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SignInLayout(
      formKey: _formKey,
      onEmailSubmitted: _handleEmailSubmit,
      onPasswordSubmitted: _handlePasswordSubmit,
      passwordController: _passwordController,
      passwordFocusNode: _passwordFocusNode,
      passwordValidator: _validatePassword,
      emailValidator: _validateEmail,
      focusNode: _fieldFocusNode,
      controller: _controller,
      showPasswordField: _showPasswordField,
      onActionButtonPress:
          _showPasswordField ? _handlePasswordSubmit : _handleEmailSubmit,
    );
  }
}
