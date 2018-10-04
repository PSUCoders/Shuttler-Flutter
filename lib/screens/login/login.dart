import 'package:flutter/material.dart';

import 'package:shuttler_ios/screens/home/home.dart';

bool _isLogging = false;

class LoginWithEmailScreen extends StatefulWidget {
  @override
  _LoginWithEmailScreenState createState() => _LoginWithEmailScreenState();
}

class _LoginWithEmailScreenState extends State<LoginWithEmailScreen> {
  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  static final passwordController = new TextEditingController();
  static final emailController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.red,
                  )),
                  child: Text("Type your Email")),
              emailInput(),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.red,
                  )),
                  child: Text("Type your password")),
              passwordInput(),
              loginButton(),
              switchPageButton()
            ]
          ),
        )
      )
    );
  }

  Widget switchPageButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.lightBlueAccent.shade100,
          elevation: 5.0,
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            // color: Colors.lightBlueAccent,
            child: Text('Go to Home', style: TextStyle(color: Colors.black)),
          ),
        ));
  }

  Widget loginButton() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () { },
          // color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.black)),
        ),
      ));
  }

  Widget emailInput() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        width: 250.0,
        // color: const Color(0xFF00FF00),
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (email) => (email.contains("@")) ? "No @ found" : "Valid",
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ));
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      // color: const Color(0xFF00FF00),
      child: TextFormField(
          controller: passwordController,
          autofocus: false,
          keyboardType: TextInputType.text,
          // initialValue: 'dsd',
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )),
    );
  }

}
