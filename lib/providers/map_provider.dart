import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:shuttler_flutter/models/driver.dart';
import 'package:shuttler_flutter/services/db_service.dart';

class MapState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  StreamSubscription<List<Driver>> _driversSubscription;
  StreamSubscription<LocationData> _locationSubscription;
  List<Driver> _drivers;
  LocationData _currentLocation;

  /// Must call cancelSubcriptions when finish using
  MapState() {
    // Subscribe to driver stream

    _driversSubscription = DBService().driversStream.listen((drivers) {
      _drivers = drivers;
      print('shuttles location updated');
      notifyListeners();
    });

    _locationSubscription =
        Location().onLocationChanged().listen((LocationData currentLocation) {
      print('currentLocation updated');
      _currentLocation = currentLocation;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    print('dispose mapstate called');
    cancelSubcriptions();
    super.dispose();
  }

  // GETTERS //

  // Get all driver objects
  List<Driver> get drivers => _drivers;

  // Get location of the device
  LocationData get currentLocation => _currentLocation;

  bool get hasOneDriver => _drivers.length == 1;

  // METHODS //

  cancelSubcriptions() async {
    print('cancelling all subscriptions...');
    await _driversSubscription.cancel();
    await _locationSubscription.cancel();
  }
}
