import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:shuttler_ios/screens/login/login.dart';
import 'package:shuttler_ios/utilities/dataset.dart';
// import 'package:shuttler_ios/screens/home/map.dart';

const double _fontSize = 16.0;

List _places = ['Campus', 'Walmart', 'Target', 'Matket32', 'Unknown Place'];

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool enableNotifications;
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentPlace;
  int _timeAhead;
  DatabaseReference userNotificationRef; // Users/notifications
  FirebaseMessaging _firebaseMessaging;
  String _token;

  @override
  initState() {
    super.initState();
    enableNotifications = false;
    _firebaseMessaging = FirebaseMessaging();
    // _firebaseMessaging.getToken().then((token) {
    //   print(Dataset.currentUser.value.notifications);
    //   Map tokenRef = Dataset.currentUser.value.notifications["tokens"];
    //   if(tokenRef.containsKey(token)) {
    //     token = token;
    //     setState(() {
    //       enableNotifications = true;
    //     });
    //   }
    // });
    // print(Dataset.token.value);
    // print("token is " + Dataset.token.value);
    _token = Dataset.token.value;
    // print(Dataset.currentUser.value.notifications["tokens"][_token]);
    // print(Dataset.currentUser.value.notifications[Dataset.token.value]);
    enableNotifications = Dataset.currentUser.value.notifications["tokens"][_token];
    _dropDownMenuItems = getDropDownMenuItems();
    _currentPlace = _dropDownMenuItems[_places.indexOf(Dataset.currentUser.value.notifications['notifyLocation'])].value;
    _timeAhead = Dataset.currentUser.value.notifications['timeAhead'];
    userNotificationRef = FirebaseDatabase.instance.reference().child('Users/${Dataset.currentUser.value.key}/notifications');
  }
  
  @override
  void dispose(){
    super.dispose();
    enableNotifications = null;
    _dropDownMenuItems = null;
    _currentPlace = null;
    _timeAhead = null;
    userNotificationRef = null;
  }

  void onChangedSwitch(bool value) {
    setState(() {
      enableNotifications = value;
    });
    // userNotificationRef.child('enabled').set(value);
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
              style: TextStyle(fontSize: _fontSize, 
              fontFamily: "CircularStd-Book", 
              fontWeight: FontWeight.bold, 
              color: Colors.black38), 
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                color: Colors.white,
                child: CupertinoSwitch(
                  onChanged: onChangedSwitch,
                  value: enableNotifications,
                )
              ),
            )
          ],
        ),
      ),
    );
  }
  
  void changedDropDownItem(String selectedPlace) {
    setState(() {
      _currentPlace = selectedPlace;
    });
    // userNotificationRef.child('notifyLocation').set(selectedPlace);
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
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Notify me when the shuttle is at", 
                  style: TextStyle(fontSize: _fontSize, 
                  fontFamily: "CircularStd-Book", 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black38), 
                )
              ],
            ),
            DropdownButton(
              value: _currentPlace,
              onChanged: changedDropDownItem,
              items: _dropDownMenuItems,
              style: TextStyle(fontSize: _fontSize, 
                fontFamily: "CircularStd-Book", 
                // fontWeight: FontWeight.bold, 
                color: Colors.black,),
            )
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
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Time ahead", 
                  style: TextStyle(fontSize: _fontSize, 
                  fontFamily: "CircularStd-Book", 
                  fontWeight: FontWeight.bold, 
                  color: Colors.black38), )
              ],
            ),
            setTimeButton()
          ],
        ),
      ),
    );
  }

  void onChangedTimeAhead(int value) {
    userNotificationRef.child('timeAhead').set(value);
  }

  Widget setTimeButton() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: CupertinoButton(
                onPressed: () { 
                  setState(() {
                    if(_timeAhead == 1) {return;}
                    --_timeAhead;
                    // onChangedTimeAhead(_timeAhead);
                  });
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.black38,
                  size: 30.0,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9.0),
                    child: Text(_timeAhead.toString(), 
                      style: TextStyle(fontSize: 30.0,
                      color: Colors.black87), 
                    ),
                  ),
                  Text(" mins", 
                    style: TextStyle(fontSize: _fontSize, 
                    fontFamily: "CircularStd-Book", 
                    color: Colors.black87), 
                  ),
                ]
              ),
            ),
            Expanded(
              child: CupertinoButton(
                onPressed: () { 
                  setState(() {
                    ++_timeAhead;
                    // onChangedTimeAhead(_timeAhead);
                  });
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black38,
                  size: 30.0,
                ),
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
        onPressed: logOut,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Logout", 
            style: TextStyle(fontSize: 20.0, 
            fontFamily: "CircularStd-Book", 
            // fontWeight: FontWeight.bold,
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
          onPressed: cancelSetting,
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
          onPressed: applySetting,
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

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String place in _places) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(DropdownMenuItem(
        value: place,
        child: Text(place, 
          style: TextStyle(fontSize: _fontSize, 
          fontFamily: "CircularStd-Book", 
          // fontWeight: FontWeight.bold, 
          color: Colors.black), 
        ),
      ));
    }
    return items;
  }

  void applySetting() async {
    // userNotificationRef.child('enabled').set(enableNotifications);
    userNotificationRef.child('notifyLocation').set(_currentPlace);
    userNotificationRef.child('timeAhead').set(_timeAhead);
    if(enableNotifications) {
      userNotificationRef.child("tokens/$_token").set(true);
    }
    else {
      userNotificationRef.child("tokens/$_token").set(false);
    }

    print((await userNotificationRef.once()).value);

    Dataset.currentUser.value.notifications = (await userNotificationRef.once()).value;
    Navigator.pop(context);
  }

  void cancelSetting() {
    Navigator.pop(context);
  }

  Future<void> removeNotificationToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    var token = await firebaseMessaging.getToken();
    userNotificationRef.child(token).remove();
  }

  void logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    removeNotificationToken();
    Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => SignInScreen()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings", style: TextStyle(fontFamily: "CircularStd-Book", fontSize: 25.0, color: Colors.black54),),
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
              logoutButton(),
              FlatButton(
                onPressed: () {    
                  // Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Map()));
                },
                child: Text("Show Map")
              )
            ],
          ),
        ),
        bottomSheet: bottomMenu(),
      ),
    );
  }


}
