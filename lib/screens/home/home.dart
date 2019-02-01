import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler_ios/screens/setting/setting.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging;
  GoogleMapController mapController;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging()
      ..configure(onMessage: (message) {
        print("on message $message");
      }, onLaunch: (message) {
        print("on launch $message");
      }, onResume: (message) {
        print("on resume $message");
      });
    _firebaseMessaging.getToken().then((token) => print("token is: " + token));
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (_currentPosition == null) {
      _currentPosition = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "Shuttle Status",
            style: TextStyle(
                fontFamily: "CircularStd-Book",
                fontSize: 25.0,
                color: Colors.black54),
          ),
        ),
        elevation: 2.0,
        titleSpacing: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SettingScreen()));
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.blue,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: LatLng(75.0, 80.0)),
        ),
      ),
      bottomSheet: bottomMenu(),
    );
  }

  Widget bottomMenu() {
    return Container(
      height: 100.0,
      color: Colors.white,
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[nextStopButton(), etcButton()],
      ),
    );
  }

  Widget nextStopButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        width: 150.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Next Stop",
              style: TextStyle(
                  fontFamily: "CircularStd-Book",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2014B)),
            ),
            Icon(Icons.drive_eta),
            Text(
              "Target",
              style: TextStyle(
                  fontFamily: "CircularStd-Book",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2014B)),
            )
          ],
        ));
  }

  Widget etcButton() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        height: 70.0,
        width: 150.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Estimated Time",
              style: TextStyle(
                  fontFamily: "CircularStd-Book",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF2014B)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "6 mins",
                style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: "CircularStd-Book",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2014B)),
              ),
            )
          ],
        ));
  }
}
