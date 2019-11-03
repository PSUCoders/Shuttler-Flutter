import 'package:flutter/material.dart';
import 'package:shuttler/screens/sign_in/sign_in_screen.dart';

class PreSignInScreen extends StatelessWidget {
  const PreSignInScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.maxFinite,
              color: Colors.pink,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  // height: double.minPositive,
                  // width: double.minPositive,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(180),
                    color: Colors.white,
                  ),
                  child: Image.asset("assets/icons/ic_logo.png"),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
            child: Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Container(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Get started with Shuttler",
                      style: TextStyle(fontSize: 26),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your email",
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
