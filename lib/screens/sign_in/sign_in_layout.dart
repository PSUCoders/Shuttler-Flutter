import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shuttler/utilities/theme.dart';

typedef String TextValidator(String text);

/// A passwordless sign in layout with password field
///
/// To show password field, provide [passwordController],
/// [passwordFocusNode], [passwordValidator], [onPasswordSubmitted]
class SignInLayout extends StatelessWidget {
  SignInLayout({
    Key key,
    @required this.onEmailSubmitted,
    @required this.emailValidator,
    this.passwordController,
    this.passwordFocusNode,
    this.passwordValidator,
    this.onPasswordSubmitted,
    @required this.controller,
    @required this.focusNode,
    @required this.onActionButtonPress,
    @required this.formKey,
    this.showLoading = false,
    this.showPasswordField = false,
  }) : super(key: key);

  final Function(String email) onEmailSubmitted;
  final Function(String password) onPasswordSubmitted;
  final TextValidator emailValidator;
  final TextValidator passwordValidator;
  final TextEditingController controller;
  final TextEditingController passwordController;
  final FocusNode focusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback onActionButtonPress;
  final GlobalKey<FormState> formKey;
  final bool showLoading;
  final bool showPasswordField;

  bool get showPassword =>
      this.showPasswordField &&
      this.passwordController != null &&
      this.passwordFocusNode != null &&
      this.passwordValidator != null &&
      this.onPasswordSubmitted != null;

  Widget _emailInput() {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
      onFieldSubmitted: onEmailSubmitted,
      autofocus: true,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: Icon(Icons.email),
        hintText: "Example: jdoe011@plattsburgh.edu",
        hintStyle: TextStyle(color: Colors.black45),
      ),
    );
  }

  Widget _passwordInput() {
    return TextFormField(
      focusNode: passwordFocusNode,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      validator: passwordValidator,
      onFieldSubmitted: onPasswordSubmitted,
      autofocus: true,
      obscureText: true,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: Icon(Icons.vpn_key),
        hintStyle: TextStyle(color: Colors.black45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      floatingActionButton: FloatingActionButton(
        onPressed: onActionButtonPress,
        child: Icon(
          Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (showLoading) ...[
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: 20),
                  ],
                  Text(
                    "Enter your SUNY Plattsburgh email",
                    style: ShuttlerTheme.of(context).textTheme.headline,
                  ),
                  SizedBox(height: 10),
                  _emailInput(),
                  if (showPassword) _passwordInput(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
