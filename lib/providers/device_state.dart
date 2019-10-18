import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SHARED PREFERENCES KEYS ///
enum PrefsKey { NOTIFICATION_ON, SHUTTLE_STOP }

/// SHUTTLE STOPS ///
enum ShuttleStop {
  Campus,
  Walmart,
  Target,
  Market32,
  Jade,
}

/// Store all settings to device memory
class DeviceState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  bool _isNotificationOn;
  String _shuttleStop;
  bool _hasData = false;
  Completer<SharedPreferences> _prefs = Completer();

  DeviceState() {
    // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));
  }

  // GETTERS //

  bool get hasData => _hasData;

  bool get isNotificationOn => _isNotificationOn ?? false;

  String get shuttleStop => _shuttleStop ?? "";

  // METHODS //

  fetchStates() async {
    SharedPreferences prefs = await _prefs.future;
    await prefs.reload();

    PrefsKey.values.forEach((key) async {
      switch (key) {
        case PrefsKey.NOTIFICATION_ON:
          {
            _isNotificationOn = prefs.getBool(key.toString());
            break;
          }
        case PrefsKey.SHUTTLE_STOP:
          {
            _shuttleStop = prefs.getString(key.toString());
            break;
          }
      }
    });
    _hasData = true;
    notifyListeners();
  }

  turnNotificationOn(bool value) async {
    SharedPreferences prefs = await _prefs.future;
    await prefs.setBool(PrefsKey.NOTIFICATION_ON.toString(), value);
    _isNotificationOn = value;
    notifyListeners();
  }

  changeShuttleStop(ShuttleStop value) async {
    SharedPreferences prefs = await _prefs.future;
    await prefs.setString(
        PrefsKey.SHUTTLE_STOP.toString(), value.toString().split('.')[1]);
    _shuttleStop = prefs.getString(PrefsKey.SHUTTLE_STOP.toString());
    notifyListeners();
  }
}
