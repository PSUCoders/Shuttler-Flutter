import 'package:flutter/material.dart';
import 'package:shuttler/utilities/theme.dart';

class SignInMaterial extends StatefulWidget {
  SignInMaterial({
    Key key,
    @required this.onSendEmailPress,
  }) : super(key: key);

  final Function(String email) onSendEmailPress;

  @override
  _SignInMaterialState createState() => _SignInMaterialState();
}

class _SignInMaterialState extends State<SignInMaterial> {
  TextEditingController _controller = TextEditingController();

  FlatButton _sendEmailLinkButton(BuildContext context) {
    return FlatButton(
      textColor: ShuttlerTheme.of(context).primaryColor,
      onPressed: () {
        print('button pressed');
        widget.onSendEmailPress(_controller.text);
      },
      child: Text("Send"),
    );
  }

  Expanded _emailInput() {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
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
