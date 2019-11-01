import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignInCupertino extends StatefulWidget {
  SignInCupertino({
    Key key,
    this.onSendEmailPress,
  }) : super(key: key);

  final Function(String email) onSendEmailPress;

  @override
  _SignInCupertinoState createState() => _SignInCupertinoState();
}

class _SignInCupertinoState extends State<SignInCupertino> {
  TextEditingController _controller = TextEditingController();

  showAlert() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          actions: <Widget>[
            CupertinoButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Okay"),
            )
          ],
          content: Text("Wrong email format"),
        );
      },
    );
  }

  Widget _buildSendEmailButton(Function(String) onPressed) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        onPressed(_controller.text);
      },
      child: Text(
        "Send",
        style: TextStyle(
          // color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      width: screenW * 0.7,
      child: CupertinoTextField(
        controller: _controller,
        placeholder: "SUNY Plattsburgh email",
        keyboardType: TextInputType.emailAddress,
        prefix: Container(
          padding: EdgeInsets.all(5),
          child: Icon(Icons.email),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/icons/ic_logo.png"),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildEmailInput(),
                  SizedBox(width: 10),
                  _buildSendEmailButton(widget.onSendEmailPress),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
