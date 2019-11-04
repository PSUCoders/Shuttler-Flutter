import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shuttler/utilities/theme.dart';

typedef String EmailValidator(String email);

class SignInLayout extends StatelessWidget {
  SignInLayout({
    Key key,
    @required this.onEmailSubmitted,
    @required this.emailValidator,
    @required this.controller,
    @required this.focusNode,
    @required this.onActionButtonPress,
    @required this.formKey,
    this.showLoading = false,
  }) : super(key: key);

  final Function(String email) onEmailSubmitted;
  final EmailValidator emailValidator;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onActionButtonPress;
  final GlobalKey<FormState> formKey;
  final bool showLoading;

  Widget _emailInput() {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: Icon(Icons.email),
        hintText: "Example: jdoe011@plattsburgh.edu",
        hintStyle: TextStyle(color: Colors.black45),
      ),
      onFieldSubmitted: onEmailSubmitted,
      autofocus: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
