import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler_ios/screens/setting/setting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shuttler_ios/utilities/dataset.dart';
import 'package:shuttler_ios/models/driver.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging;
  GoogleMapController mapController;
  Position _currentPosition;
  DatabaseReference _drivers;
  DatabaseReference _driver;

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

  void _getDrivers() async {
    final FirebaseDatabase database =
        FirebaseDatabase(app: Dataset.firebaseApp.value);
    _drivers = database.reference().child('Drivers');
    var snapshot = await _drivers.once();

    _driver =
        database.reference().child('Drivers/${snapshot.value.keys.first}');
    var driverSnapshot = await _driver.once();
    print(driverSnapshot.value);

    _driver.onValue.listen(_onDriverChanged);
  }

  /// Animate the map camera to the driver location
  void _goToDriver() async {
    var snapshot = await _driver.once();
    var newDriver = Driver.fromSnapshot(snapshot);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newDriver.getLatLng(),
      zoom: 15,
    )));
  }

  _onDriverChanged(Event event) async {
    var newDriver = Driver.fromSnapshot(event.snapshot);
    mapController.clearMarkers();
    Marker marker = await mapController.addMarker(MarkerOptions(
      position: newDriver.getLatLng(),
      icon: BitmapDescriptor.fromAsset("assets/icons/2.0x/ic_shuttle@2x.png"),
    ));
  }

  void _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (_currentPosition == null) {
      _currentPosition = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    }

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 15,
    )));
    print(_currentPosition);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;

      _getDrivers();
    });
  }

  Widget _buildBottomMenu() {
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
    return GestureDetector(
      onTap: () {
        // print(_currentPosition);
        _getDrivers();
        _goToDriver();
      },
      child: Container(
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
              Image.asset("assets/switch_thumb.png",
                height: 30,
              ),
              Text(
                "Target",
                style: TextStyle(
                    fontFamily: "CircularStd-Book",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2014B)),
              )
            ],
          )),
    );
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

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.blue,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                          target: LatLng(_currentPosition.latitude,
                              _currentPosition.longitude))
                      : CameraPosition(target: LatLng(70, 70)),
                ),
              ),
              Positioned(
                  bottom: 15,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      _goToDriver();
                    },
                    child: Image.asset(
                      "assets/switch_thumb.png",
                      height: 50,
                      width: 50,
                    ),
                  ))
            ],
          ),
        ),
        _buildBottomMenu(),
      ],
    );
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
                color: Colors.black87),
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
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: _buildBody(),
      bottomSheet: _buildBottomMenu(),
    );
  }
}
