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
  int _currentDriver = 0;

  /// Must call cancelSubcriptions when finish using
  MapState() {
    // Subscribe to driver stream
    _driversSubscription =
        OnlineDB().driversStream().listen(_driversSubscriptionHandler);
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
  List<Driver> get drivers => _drivers ?? [];

  List<Driver> get activeDrivers =>
      _drivers.where((driver) => driver.active).toList() ?? [];

  bool get hasOneDriver => _drivers.length == 1;

  LatLng get focusDriverLocation {
    if (activeDrivers.length == 0) return null;

    _currentDriver = (_currentDriver + 1) % activeDrivers.length;

    return activeDrivers[_currentDriver].latLng;
  }

  List<Driver> get allDriversLocations => _drivers != null ? _drivers : null;

  bool get hasActiveDriver {
    return drivers.where((driver) => driver.active).toList().length > 0;
  }

  /// TODO make this dynamic
  String get nextStop => "Walmart";

  // PRIVATE METHODS //

  void _driversSubscriptionHandler(drivers) {
    drivers.forEach((newDriver) {
      Driver oldDriver = this.drivers.firstWhere(
          (driver) => driver.id == newDriver.id,
          orElse: () => null);

      final direction = _getDirection(oldDriver, newDriver);
      newDriver.direction = direction;
    });

    _drivers = drivers;
    print('shuttles location updated');
    notifyListeners();
  }

  double _getDirection(Driver oldDriver, Driver newDriver) {
    double direction = 0;

    if (oldDriver != null) {
      if (newDriver.longitude - oldDriver.longitude == 0) {
        if (newDriver.latitude - oldDriver.latitude < 0) {
          direction = 180;
        } else if (newDriver.latitude - oldDriver.latitude == 0) {
          direction = oldDriver.direction;
        } else {
          direction = 0;
        }
      } else {
        direction = atan((newDriver.longitude - oldDriver.longitude) /
                (newDriver.latitude - oldDriver.latitude)) /
            pi *
            180;

        if (newDriver.latitude - oldDriver.latitude < 0) direction += 180;
      }
    } else {
      direction = 90;
    }

    return direction;
  }

  // PUBLIC METHODS //

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

  Future<void> cancelSubcriptions() async {
    print('cancelling all subscriptions...');
    await Future.wait([
      _driversSubscription.cancel(),
    ]);
  }

  void pauseSubscriptions() {
    _driversSubscription.pause();
    print("MapState subsription paused");
  }

  void resumeSubscriptions() {
    _driversSubscription.resume();
    print("MapState subsription resumed");
  }
}
