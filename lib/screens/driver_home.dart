import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const String message =
"""Dear driver, 
please turn on if you are on duty.

Don't forget to turn off once you are out of duty.""";

class DriverHomeScreen extends StatefulWidget {
  @override
  DriverHomeScreenState createState() => DriverHomeScreenState();
}

class DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: SizedBox(
              height: screen.height * 0.3,
              width: screen.width * 4 / 5,
              child: Center(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 25, color: Colors.black54, ),
                  textAlign: TextAlign.center,
              )),
            ),
          ),
          SizedBox(
            height: screen.height * 0.3,
            child: Image.asset("assets/switch_off.png")
          ),
          SizedBox(
            height: screen.height * 0.3,
            child: Column(
              children: <Widget>[
                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                  onPressed: () {
                    print("clicked");
                  },
                  child: Text("LOGOUT"),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
