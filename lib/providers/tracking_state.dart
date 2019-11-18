import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:flutter_background_location/flutter_background_location.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/services/online_db.dart';

Duration _locationUpdateInterval = Duration(seconds: 5);

/// Store all settings to device memory
class TrackingState extends ChangeNotifier {
  Completer<SharedPreferences> _prefs = Completer();
  Location _location = Location();
  bool _hasData;
  bool _loadFailed;
  Driver _driver;
  StreamSubscription<Driver> _driverSubscription;
  StreamSubscription<LocationData> _locationSubcription;
  Timer _timer;
  bool _permissionDenied;
  DateTime _lastTime = DateTime.now();

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

  Driver get driver => _driver;

  // PRIVATE METHODS //

  void _locationChangeHandler(LocationData currentLocation) async {
    print('_locationChangeHandler fired');
    print('difference ${DateTime.now().difference(_lastTime).inSeconds}');

    print(await LocationPermissions().checkServiceStatus());

    if (DateTime.now().difference(_lastTime).inSeconds <
        _locationUpdateInterval.inSeconds) return;

    if (isTracking) {
      _lastTime = DateTime.now();

      print('currentLocation $currentLocation');

      if (currentLocation != null) {
        final newLocation = GeoPoint(
          currentLocation.latitude,
          currentLocation.longitude,
        );

        print('same location ${newLocation == _driver.location}');

        // If there is no changes then stop updating
        // TODO upgrade to check minor changes rather than no changes
        if (newLocation == _driver.location) return;

        _driver.location = newLocation;

        await OnlineDB.instance.updateDriver(_driver);

        print('location updated');
        _lastTime = DateTime.now();
      }
    }
  }

  /// Start periodic timer that fires _handleTimer every _locationUpdateInterval
  void _startTimer() {
    print('starting timer...');
    _timer = Timer.periodic(
        _locationUpdateInterval, (timer) => _lastTime = DateTime.now());
  }

  void _cancelTimer() {
    print('canceling timer...');
    _timer?.cancel();
  }

  // PUBLIC METHODS //

  Future<void> loadData() async {
    final user = await FirebaseAuth.instance.currentUser();

    if (user == null) {
      _hasData = true;
      _driver = null;
      _loadFailed = true;
      return;
    }

    _driver = await OnlineDB.instance.getDriver(user.uid) ??
        Driver(active: false, id: user.uid);

    _location.onLocationChanged().listen(_locationChangeHandler);

    if (_driver.active) _startTimer();

    notifyListeners();
  }

  Future<void> toggleTracking() async {
    print('switching tracking to ${!isTracking}...');

    if (isTracking) {
      _cancelTimer();
      FlutterBackgroundLocation.stopLocationService();
    } else {
      final status = await LocationPermissions().checkPermissionStatus();

      if (status == PermissionStatus.granted) {
        _startTimer();
        FlutterBackgroundLocation.startLocationService();
      } else if (status == PermissionStatus.denied) {
        _permissionDenied = true;
        notifyListeners();
        return;
      } else {
        final newStatus = await LocationPermissions().requestPermissions();
        if (newStatus != PermissionStatus.granted) {
          //
          print('user did not allow location');
          return;
        }
      }
    }

    _driver.active = !isTracking;
    await OnlineDB.instance.updateDriver(_driver);
    notifyListeners();
  }

  void cancelServices() {
    _driverSubscription?.cancel();
    _locationSubcription?.cancel();
    _cancelTimer();
  }
}
