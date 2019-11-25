import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/services/online_db.dart';

double _filterDistance = 10.0;
int _updateInterval = Duration(seconds: 5).inMilliseconds;

/// Tracking shuttle business logic
class TrackingState extends ChangeNotifier {
  Completer<SharedPreferences> _prefs = Completer();
  Location _location = Location();
  bool _hasData;
  bool _loadFailed;
  Driver _driver;
  StreamSubscription<Driver> _driverSubscription;
  StreamSubscription<LocationData> _locationSubcription;
  bool _permissionDenied;

  TrackingState() {
    // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));
    loadData();
  }

  @override
  void dispose() {
    cancelServices();
    FlutterBackgroundLocation.stopLocationService();
    super.dispose();
  }

  // GETTERS //

  bool get loadFailed => _loadFailed ?? false;

  bool get hasData => _hasData ?? false;

  bool get isTracking => _driver?.active ?? false;

  bool get isPermissionDenied => _permissionDenied ?? false;

  // PRIVATE METHODS //

  void _driverSubscriptionHandler(Driver driver) async {
    //
    print('_driverSubscriptionHandler fire');

    if (driver != null) {
      if (!driver.active && _driver.active) {
        toggleTracking(false);
      } else if (driver.active && !_driver.active) {
        toggleTracking(true);
      }

      _driver = driver;
      notifyListeners();
    }
  }

  void _locationSubscriptionHandler(LocationData currentLocation) async {
    print('_locationChangeHandler fired');

    try {
      if (isTracking) {
        print('currentLocation not null ${currentLocation != null}');

        if (currentLocation != null) {
          final newLocation = GeoPoint(
            currentLocation.latitude,
            currentLocation.longitude,
          );

          await OnlineDB.instance.updateDriver(
            _driver.copyWith(location: newLocation),
          );

          print('location updated');
        }
      }
    } on PlatformException catch (error) {
      print('error $error');
      await OnlineDB.instance.writeDriverLog(_driver.id, error);
    }
  }

  // PUBLIC METHODS //

  Future<void> loadData() async {
    print('Tracking State is loading data...');

    final user = await FirebaseAuth.instance.currentUser();

    if (user == null) {
      _hasData = true;
      _driver = null;
      _loadFailed = true;
      return;
    }

    _driver = await OnlineDB.instance.getDriver(user.uid);

    // First time this driver login and turn on tracking
    if (_driver == null) {
      final firstLocation = await _location.getLocation();

      print('driver email ${user.email}');
      _driver = Driver(
        active: false,
        id: user.uid,
        email: user.email,
        location: GeoPoint(
          firstLocation.latitude,
          firstLocation.longitude,
        ),
      );
    }

    await _location.changeSettings(
      distanceFilter: _filterDistance,
      interval: _updateInterval,
    );
    _locationSubcription =
        _location.onLocationChanged().listen(_locationSubscriptionHandler);

    _driverSubscription = OnlineDB.instance
        .driverStream(_driver.id)
        .listen(_driverSubscriptionHandler);

    notifyListeners();
  }

  Future<void> toggleTracking(bool tracking) async {
    print('switching tracking to $tracking...');

    try {
      if (!tracking) {
        _driver.active = tracking;
        await OnlineDB.instance
            .updateDriver(_driver.copyWith(active: tracking));
        FlutterBackgroundLocation.stopLocationService();
      } else {
        final status = await LocationPermissions().checkPermissionStatus();

        if (status == PermissionStatus.granted) {
          await OnlineDB.instance
              .updateDriver(_driver.copyWith(active: tracking));
          _driver.active = tracking;
          FlutterBackgroundLocation.startLocationService();
        } else if (status == PermissionStatus.denied) {
          _permissionDenied = true;
        } else {
          final newStatus = await LocationPermissions().requestPermissions();
          if (newStatus != PermissionStatus.granted) {
            //
            print('user did not allow location');
          }
        }
      }
      notifyListeners();
    } on PlatformException catch (error) {
      print('error $error');
      await OnlineDB.instance.writeDriverLog(_driver.id, error);
    }
  }

  void cancelServices() {
    _driverSubscription?.cancel();
    _locationSubcription?.cancel();
  }
}
