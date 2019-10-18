import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:shuttler_flutter/models/driver.dart';
import 'package:shuttler_flutter/services/db_service.dart';

class PermissionState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  StreamSubscription<LocationData> _locationSubscription;
  LocationData _currentLocation;
  bool _hasPermission;

  /// Must call cancelSubcriptions when finish using
  PermissionState() {
    // Subscribe to driver stream
  }

  // GETTERS //

  bool get hasPermission => _hasPermission;

  // METHODS //

  requestPermission() async {
    await Location().requestPermission();
  }

  cancelSubcriptions() async {}
}
