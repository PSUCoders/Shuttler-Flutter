import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool enableNotifications;

  @override
  initState() {
    super.initState();
    enableNotifications = false;
  }
  
  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.black),),
        elevation: 2.0,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        child: ListView(
          children: <Widget>[
            enableNotificationSwitch(),
            notifyButton(),
            timeAheadButton(),
            setTimeButton(),
            logoutButton(),
          ],
        ),
      ),
      bottomSheet: bottomMenu(),
    );
  }

  Widget enableNotificationSwitch() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        child: Row(
          children: <Widget>[
            Text("Enable Notifications", 
              style: TextStyle(fontSize: 20.0, 
              fontFamily: "CircularStd-Book", 
              fontWeight: FontWeight.bold, 
              color: Colors.black38), 
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                color: Colors.white,
                child: CupertinoSwitch(
                  onChanged: (value) {
                    setState(() {
                      enableNotifications = value;
                    });
                  },
                  value: enableNotifications,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget notifyButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Text("Notify me when the shuttle is at", 
              style: TextStyle(fontSize: 20.0, 
              fontFamily: "CircularStd-Book", 
              fontWeight: FontWeight.bold, 
              color: Colors.black38), )
          ],
        ),
      ),
    );
  }

  Widget timeAheadButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Text("Time ahead", 
              style: TextStyle(fontSize: 20.0, 
              fontFamily: "CircularStd-Book", 
              fontWeight: FontWeight.bold, 
              color: Colors.black38), )
          ],
        ),
      ),
    );
  }

  Widget setTimeButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text("5", 
                      style: TextStyle(fontSize: 30.0,
                      color: Colors.black38), 
                    ),
                  ),
                  Text(" mins", 
                    style: TextStyle(fontSize: 20.0, 
                    fontFamily: "CircularStd-Book", 
                    color: Colors.black38), 
                  ),
                ]
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Container(
      child: CupertinoButton(
        padding: EdgeInsets.all(20.0),
        pressedOpacity: 0.5,
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFF2014B),
        onPressed: () {
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Logout", 
            style: TextStyle(fontSize: 20.0, 
            fontFamily: "CircularStd-Book", 
            fontWeight: FontWeight.bold,
            color: Colors.white), 
          ),
        ),
      ),
    );
  }

  Widget bottomMenu() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          cancelButton(),
          applyButton()
        ],
      ),
    );
  }

  Widget cancelButton() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 15.0),
        child: CupertinoButton(
          padding: EdgeInsets.all(20.0),
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffe2e2e2),
          onPressed: () {
          },
          child: Text("CANCEL", 
            style: TextStyle(fontSize: 20.0, 
            fontFamily: "CircularStd-Book",
            fontWeight: FontWeight.bold,
            color: Colors.black87), 
          ),
        ),
      ),
    );
  }

  Widget applyButton() {
    return Expanded(
      child: Container(
        child: CupertinoButton(
          padding: EdgeInsets.all(20.0),
          pressedOpacity: 0.5,
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFF2014B),
          onPressed: () {
          },
          child: Text("APPLY", 
            style: TextStyle(fontSize: 20.0, 
            fontFamily: "CircularStd-Book", 
            fontWeight: FontWeight.bold,
            color: Colors.white), 
          ),
        ),
      ),
    );
  }

}
