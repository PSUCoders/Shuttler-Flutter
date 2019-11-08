import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
      print('driver');
      print(drivers);
      drivers.forEach((newDriver) {
        Driver oldDriver;
        oldDriver = _drivers == null
            ? null
            : _drivers.firstWhere((driver) => driver.id == newDriver.id,
                orElse: () => null);
        if (oldDriver != null) {
          if (newDriver.latLng.longitude - oldDriver.latLng.longitude == 0) {
            if (newDriver.latLng.latitude - oldDriver.latLng.latitude < 0) {
              newDriver.direction = 180;
            } else {
              newDriver.direction = 0;
            }
          } else {
            newDriver.direction = atan((newDriver.latLng.longitude -
                        oldDriver.latLng.longitude) /
                    (newDriver.latLng.latitude - oldDriver.latLng.latitude)) /
                pi *
                180;
          }
        } else {
          newDriver.direction = 90;
        }
        print(newDriver.direction);
        print(newDriver.id);
      });
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

  bool get hasData => _drivers != null ? true : false;

  // Get all driver objects
  List<Driver> get drivers => _drivers;

  // Get location of the device
  LatLng get currentLocation => _currentLocation;

  bool get hasOneDriver => _drivers.length == 1;

  LatLng get driverLocation => _drivers != null ? _drivers[0].latLng : null;

  List<Driver> get allDriversLocations => _drivers != null ? _drivers : null;

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

  getDriverStream(String driverId) {
    var driver = OnlineDB().driverStream(driverId);
  }

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
