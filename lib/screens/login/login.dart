import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shuttler_ios/screens/home/home.dart';
import 'package:shuttler_ios/screens/setting/setting.dart';

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
  bool showPassword;
  String showPasswordURL = "assets/icons/2.0x/ic_eye_off@2x.png";

  @override
  initState() {
    super.initState();
    showPassword = false;
  }


  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 30.0),
                child: Opacity(
                  opacity: 1.0,
                  child: Image.asset(
                    "assets/icons/2.0x/ic_logo@2x.png", scale: 2.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 50.0),
                child: Text("Don't Miss The Shuttle Any More!", style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black38),)
              ),
              emailInput(),
              passwordInput(),
              loginButton(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Text("Don't have an acocunt yet? ", style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0)),
                      ),
                      Text("Sign Up", style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(242, 1, 75, 1.0),))
                    ],),
                ),
              )
            ]
          ),
        ),
      )
    );
  }

  

  Widget loginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Container(
        child: CupertinoButton(
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xFFF2014B),
          onPressed: () {
            // TODO Implement this function
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()),);
          },
          child: Text("Sign In")
        ),
      ),
    );
  }

  Widget emailInput() {
    return Container(
      padding: const EdgeInsets.only(top: 50.0),
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
        style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, color: Colors.black, decoration: TextDecoration.none),
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (email) => (email.contains("@")) ? "No @ found" : "Valid",
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              // padding: const EdgeInsetsDirectional.only(start: 10.0),
              child: Image.asset("assets/icons/2.0x/ic_user@2x.png", scale: 1.5,),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500]),
          hintText: "Username",
        ),
      ));
  }

  Widget passwordInput() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 250.0,
      child: TextFormField(
        style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        controller: passwordController,
        keyboardType: TextInputType.text,
        obscureText: showPassword,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 2.0, 10.0, 0.0),
              child: Image.asset("assets/icons/2.0x/ic_lock@2x.png", scale: 1.5,),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 10.0, 5.0),
          hintStyle: TextStyle(fontFamily: "CircularStd-Book", fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey[500] ),
          hintText: 'Password',
          suffixIcon: Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: CupertinoButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                  if(showPassword) { showPasswordURL = "assets/icons/2.0x/ic_eye_off@2x.png"; }  
                  else { showPasswordURL = "assets/icons/2.0x/ic_eye_on@2x.png"; }
                });
              },
               child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                // padding: const EdgeInsetsDirectional.only(start: 10.0),
                child: Image.asset(showPasswordURL, scale: 1.5,),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
