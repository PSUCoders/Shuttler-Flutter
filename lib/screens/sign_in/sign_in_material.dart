import 'package:flutter/material.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/theme.dart';
import 'package:shuttler/utilities/validator.dart';

typedef String EmailValidator(String email);

class SignInMaterial extends StatefulWidget {
  SignInMaterial({
    Key key,
    @required this.onSendEmailPress,
    this.emailValidator,
  }) : super(key: key);

  final Function(String email) onSendEmailPress;
  final EmailValidator emailValidator;

  @override
  _SignInMaterialState createState() => _SignInMaterialState();
}

class _SignInMaterialState extends State<SignInMaterial> {
  TextEditingController _controller = TextEditingController();

  Widget _sendEmailLinkButton(BuildContext context) {
    return FlatButton(
      textColor: ShuttlerTheme.of(context).primaryColor,
      onPressed: () {
        print('button pressed');
        widget.onSendEmailPress(_controller.text.trim());
      },
      child: Text("Send"),
    );
  }

  Widget _emailInput() {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        validator: widget.emailValidator ??
            (email) => Validator.isPlattsburghEmail(email)
                ? null
                : ErrorMessages.wrongEmail,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: Icon(Icons.email),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Form(
            child: Column(
              children: <Widget>[
                Image.asset("assets/icons/ic_logo.png"),
                Row(
                  children: <Widget>[
                    _emailInput(),
                    _sendEmailLinkButton(context)
                  ],
                )
              ],
            ),
          Column(
            children: <Widget>[
              Image.asset("assets/icons/shuttler_logo_labeled.png"),
              Row(
                children: <Widget>[
                  _emailInput(),
                  _sendEmailLinkButton(context)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
