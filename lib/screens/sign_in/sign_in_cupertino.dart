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
      onPressed: () => onPressed(_controller.text.trim()),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter your email",
            style: TextStyle(fontSize: 26),
          ),
          SizedBox(height: 20),
          // Text(
          //   "Enter your email",
          //   style: TextStyle(
          //     color: Colors.black38,
          //     fontSize: 20,
          //   ),
          // ),
          Material(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "hint",
                enabled: false,
                filled: false,
                icon: Icon(Icons.email),
                labelText: "Email",
                fillColor: Colors.red,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
            ),
          ),
          // CupertinoTextField(),
          SizedBox(height: 10),
        ],
      ),
    );

    // return Container(
    //   width: screenW * 0.7,
    //   child: CupertinoTextField(
    //     controller: _controller,
    //     placeholder: "SUNY Plattsburgh email",
    //     keyboardType: TextInputType.emailAddress,
    //     prefix: Container(
    //       padding: EdgeInsets.all(5),
    //       child: Icon(Icons.email),
    //     ),
    //     decoration: BoxDecoration(
    //       color: Colors.grey[200],
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              CupertinoNavigationBarBackButton(),
              Image.asset("assets/icons/shuttler_logo_labeled.png"),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: Image.asset("assets/icons/ic_logo.png")),
                _buildEmailInput(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // _buildEmailInput(),
                    SizedBox(width: 10),
                    // _buildSendEmailButton(widget.onSendEmailPress),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
