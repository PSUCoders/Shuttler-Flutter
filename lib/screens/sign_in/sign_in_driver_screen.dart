import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/validator.dart';

class SignInDriverScreen extends StatefulWidget {
  SignInDriverScreen({Key key}) : super(key: key);

  @override
  _SignInDriverScreenState createState() => _SignInDriverScreenState();
}

class _SignInDriverScreenState extends State<SignInDriverScreen> {
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String _errorMessage = "";

  @override
  void dispose() {
    _passwordFocusNode.unfocus();
    _emailFocusNode.unfocus();
    super.dispose();
  }

  Future<void> _signInAsDriver() async {
    final AuthState authState = Provider.of<AuthState>(context, listen: false);

    try {
      final result = await authState.signInAsDriver(
          _emailController.text, _passwordController.text);

      if (result == null) return;

      print('signed in as ${result.user.email}');

      Navigator.pushNamedAndRemoveUntil(context, '/driver', (route) => false);
    } on PlatformException catch (error) {
      setState(() {
        _errorMessage = error.message;
      });
    }
  }

  /// Handle the event of finishing typing the password
  void _handleFormSubmit([String text]) {
    _emailFocusNode.unfocus(); // Close the keyboard
    _passwordFocusNode.unfocus(); // Close the keyboard

    final noError = _formKey.currentState.validate();

    // Clear error messages
    setState(() => _errorMessage = "");

    if (noError) {
      print('form has no error');
      _signInAsDriver();
    }
  }

  void _handleEmailSubmit(String email) {
    _emailFocusNode.unfocus();
    _passwordFocusNode.requestFocus();
  }

  void _handlePasswordSubmit(String email) {
    _passwordFocusNode.unfocus();
  }

  String _validateEmail(String email) {
    if (Validator.isEmail(email)) return null;

    return ErrorMessages.wrongEmail;
  }

  String _validatePassword(String password) {
    if (Validator.isPassword(password)) return null;

    return ErrorMessages.wrongDriverPassword;
  }

  Widget _emailInput() {
    return TextFormField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: _validateEmail,
      decoration: InputDecoration(
        labelText: "Email",
        filled: false,
        prefixIcon: Icon(Icons.email),
        hintStyle: TextStyle(color: Colors.black45),
      ),
      onFieldSubmitted: _handleEmailSubmit,
      autofocus: true,
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      obscureText: true,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: _validatePassword,
      decoration: InputDecoration(
        labelText: "Password",
        filled: false,
        prefixIcon: Icon(Icons.lock),
        hintStyle: TextStyle(color: Colors.black45),
      ),
      onFieldSubmitted: _handlePasswordSubmit,
    );
  }

  Widget _buldSignInButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: _handleFormSubmit,
        child: Text("Sign In"),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50),
      height: 100,
      width: 100,
      child: Image.asset(
        "assets/icons/shuttler_logo_labeled.png",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        _buildLogo(),
                        Text(
                          "Welcome to Shuttler!",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Please sign in with driver credential",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        SizedBox(height: 40),
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: Theme.of(context).textTheme.display2,
                          ),
                        _emailInput(),
                        _passwordInput(),
                        _buldSignInButton(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
