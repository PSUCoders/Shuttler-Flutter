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
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(180),
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(180),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          "assets/icons/shuttler_logo_labeled.png",
                        ),
                      ),
                    ),
                  ),
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
