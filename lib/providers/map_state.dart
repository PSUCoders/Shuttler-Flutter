import 'dart:async';
import 'dart:core';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/services/online_db.dart';

class MapState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  StreamSubscription<List<Driver>> _driversSubscription;
  List<Driver> _drivers;
  LatLng _currentLocation;

  /// Must call cancelSubcriptions when finish using
  MapState() {
    // Subscribe to driver stream
    _driversSubscription = OnlineDB().driversStream().listen((drivers) {
      _drivers = drivers;
      print('shuttles location updated');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    print('disposing mapstate...');
    cancelSubcriptions();
    super.dispose();
  }

  // GETTERS //

  bool get hasData => drivers != null ? true : false;

  // Get all driver objects
  List<Driver> get drivers => _drivers;

  // Get location of the device
  LatLng get currentLocation => _currentLocation;

  bool get hasOneDriver => _drivers.length == 1;

  LatLng get driverLocation => _drivers != null ? _drivers[0].latLng : null;

  /// TODO make this dynamic
  String get nextStop => "Walmart";

  // METHODS //

  Future<LatLng> getCurrentLocation() async {
    final location = Location();
    LocationData locationData;

    try {
      locationData = await location.getLocation();

      final latLng = LatLng(locationData.latitude, locationData.longitude);
      return latLng;
    } on PlatformException catch (e) {
      print('Exception occurred');
      if (e.code == 'PERMISSION_DENIED') {
        print(e.message);
      }
      return null;
    }
  }

  getDriverStream(String driverId) => OnlineDB().driverStream(driverId);

  Future<void> cancelSubcriptions() async {
    print('cancelling all subscriptions...');
    await Future.wait([
      _driversSubscription.cancel(),
    ]);
  }

  pauseSubscriptions() {
    _driversSubscription.pause();
    print("MapState subsription paused");
  }

  resumeSubscriptions() {
    _driversSubscription.resume();
    print("MapState subsription resumed");
  }
}
