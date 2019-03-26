import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler_flutter/screens/setting/setting.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:shuttler_flutter/utilities/dataset.dart';
import 'package:shuttler_flutter/models/driver.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging;
  GoogleMapController mapController;
  // Position _currentPosition;
  LocationData _currentLocation;
  DatabaseReference _drivers;
  DatabaseReference _driver;
  String _locationErrorMessage;
  Set<Marker> _markers;

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
    try {
      var snapshot = await _driver.once();
      var newDriver = Driver.fromSnapshot(snapshot);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: newDriver.getLatLng(),
        zoom: 15,
      )));
    } catch (e) {
      print(e);
    }
  }

  _onDriverChanged(Event event) async {
    var newDriver = Driver.fromSnapshot(event.snapshot);
    // mapController.clearMarkers();
    setState(() {
      _markers = Set()
        ..add(Marker(
            markerId: MarkerId("shuttle"), position: newDriver.getLatLng()));
    });
    // Marker marker = await mapController.addMarker(MarkerOptions(
    //   position: newDriver.getLatLng(),
    //   icon: BitmapDescriptor.fromAsset("assets/icons/2.0x/ic_shuttle@2x.png"),
    // ));
  }

  void _getCurrentLocation() async {
    // _currentPosition = await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // if (_currentPosition == null) {
    //   _currentPosition = await Geolocator()
    //       .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    // }

    var location = Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var here = await location.getLocation();

      setState(() {
        _currentLocation = here;
      });

      if (mapController != null) {
        print("map controller not null");

        setState(() {
          _currentLocation = here;
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _locationErrorMessage = 'Permission denied';
      }
      _currentLocation = null;
    }
    // print(_currentLocation);
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
        children: <Widget>[_buildNextStopButton(), _buildEstButton()],
      ),
    );
  }

  Widget _buildNextStopButton() {
    return GestureDetector(
      onTap: () {
        // print(_currentPosition);
        // _getDrivers();
        // _goToDriver();
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
              Image.asset(
                "assets/switch_thumb.png",
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

  Widget _buildEstButton() {
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

  Widget _buildGoogleMap() {
    // if (_currentLocation != null) {
    //   return Container(
    //     color: Colors.white,
    //     child: GoogleMap(
    //       onMapCreated: _onMapCreated,
    //       myLocationEnabled: _currentLocation != null ? true : false,
    //       compassEnabled: true,
    //       markers: _markers,
    //       initialCameraPosition: _currentLocation != null
    //           ? CameraPosition(
    //               target: LatLng(
    //                   _currentLocation.latitude, _currentLocation.longitude))
    //           : CameraPosition(target: LatLng(70, 70)),
    //     ),
    //   );
    // } else {
    //   return Container(
    //     child: Center(
    //       child:
    //           Text(_locationErrorMessage ?? "Please allow device's location"),
    //     ),
    //   );
    // }
    print(
        "current location: lat : ${_currentLocation?.latitude} long: ${_currentLocation?.longitude}");

    print(_currentLocation);

    return Container(
      color: Colors.white,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: _currentLocation != null ? true : false,
        compassEnabled: true,
        markers: _markers,
        // initialCameraPosition:
        //     CameraPosition(target: LatLng(44.6895415, -73.4677082), zoom: 14),
        initialCameraPosition: _currentLocation != null
            ? CameraPosition(
                zoom: 14,
                target: LatLng(
                    _currentLocation.latitude, _currentLocation.longitude))
            : CameraPosition(target: LatLng(44, 70)),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              _buildGoogleMap(),
              Positioned(
                  bottom: 15,
                  right: 5,
                  child: GestureDetector(
                      onTap: () {
                        _goToDriver();
                      },
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(180),
                          // shape: CircleBorder(side: Bo),
                          child: Center(
                            child: Ink.image(
                              image: AssetImage('assets/switch_thumb.png'),
                              fit: BoxFit.fill,
                              width: 50.0,
                              height: 50.0,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                highlightColor: Colors.transparent,
                                splashColor: Color.fromARGB(150, 255, 0, 0),
                                onTap: () {
                                  _goToDriver();
                                },
                              ),
                            ),
                          ))))
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
