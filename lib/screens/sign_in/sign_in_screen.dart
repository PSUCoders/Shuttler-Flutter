import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/sign_in/sign_in_cupertino.dart';
import 'dart:io' show Platform;

import 'package:shuttler/screens/sign_in/sign_in_material.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/theme.dart';
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

  void _handleSendEmail() {
    final noError = _formKey.currentState.validate();

    if (noError) {
      print('no error');
      final AuthState authState = Provider.of<AuthState>(context);
      // TODO
    }
  }

  void _handleFieldSubmitted(String text) {
    // TODO
    _fieldFocusNode.unfocus();
    _handleSendEmail();
  }

  Widget _sendEmailLinkButton({@required Function onPressed}) {
    return FlatButton(
      textColor: ShuttlerTheme.of(context).primaryColor,
      onPressed: onPressed,
      child: Text("Send"),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      focusNode: _fieldFocusNode,
      controller: _controller,
      keyboardType: TextInputType.emailAddress,
      validator: (email) =>
          Validator.isPlattsburghEmail(email) ? null : ErrorMessages.wrongEmail,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(Icons.email),
      ),
      onFieldSubmitted: _handleFieldSubmitted,
    );

    // return Expanded(
    //   child: TextFormField(
    //     focusNode: _fieldFocusNode,
    //     controller: _controller,
    //     keyboardType: TextInputType.emailAddress,
    //     validator: (email) => Validator.isPlattsburghEmail(email)
    //         ? null
    //         : ErrorMessages.wrongEmail,
    //     decoration: InputDecoration(
    //       filled: true,
    //       fillColor: Colors.grey[200],
    //       prefixIcon: Icon(Icons.email),
    //     ),
    //     onFieldSubmitted: _handleFieldSubmitted,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SignInCupertino(
        onSendEmailPress: (email) {},
      );
    }

    return Material(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/icons/ic_logo.png"),
                    _emailInput(),
                    _sendEmailLinkButton(onPressed: _handleSendEmail),
                    // Row(
                    //   children: <Widget>[
                    //     _emailInput(),
                    //     _sendEmailLinkButton(onPressed: _handleSendEmail)
                    //   ],
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
