import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/utilities/contants.dart' show ShuttleStop, PrefsKey;

/// Store all settings to device memory
class DeviceState extends ChangeNotifier {
  // PRIVATE VARIABLES //
  bool _isNotificationOn;
  ShuttleStop _shuttleStop;
  String _email;
  bool _isSignIn;
  bool _isDriver;
  bool _isTester;
  bool _hasData;
  List<String> _readNotifications;
  Completer<SharedPreferences> _prefs = Completer();

  DeviceState() {
    // // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));
    fetchStates();
  }

  // GETTERS //

  bool get hasData => _hasData ?? false;

  bool get isNotificationOn => _isNotificationOn ?? false;

  bool get isSignIn => _isSignIn ?? false;

  bool get isDriver => _isDriver ?? false;

  bool get isTester => _isTester ?? false;

  /// The email the user use to sign in to the app
  String get email => _email;

  ShuttleStop get shuttleStop => _shuttleStop ?? ShuttleStop.Campus;

  /// List of notification ids that has been read on this device
  List<String> get readNotifications => _readNotifications ?? [];

  // METHODS //

  fetchStates() async {
    print('fetching device state...');
    SharedPreferences prefs = await _prefs.future;
    await prefs.reload();

    // Retrieve all of the local values
    PrefsKey.values.forEach((key) async {
      switch (key) {
        case PrefsKey.NOTIFICATION_ON:
          {
            _isNotificationOn = prefs.getBool(key.toString());
            break;
          }
        case PrefsKey.SHUTTLE_STOP:
          {
            final stopIndex =
                prefs.getInt(PrefsKey.SHUTTLE_STOP.toString()) ?? 0;

            _shuttleStop = ShuttleStop.values[stopIndex];
            break;
          }
        case PrefsKey.IS_SIGN_IN:
          {
            _isSignIn = prefs.getBool(key.toString());
            break;
          }
        case PrefsKey.EMAIL:
          {
            _email = prefs.getString(key.toString());
            break;
          }
        case PrefsKey.SEEN_NOTIFICATION:
          break;
        case PrefsKey.IS_DRIVER:
          _isDriver = prefs.getBool(key.toString());
          break;
        case PrefsKey.IS_DRIVER:
          _isTester = prefs.getBool(key.toString());
          break;
        default:
          break;
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
    await prefs.setInt(PrefsKey.SHUTTLE_STOP.toString(), value.index);
    _shuttleStop = ShuttleStop.values[value.index];
    notifyListeners();
  }

  updateReadNotifications(List<String> ids) async {
    SharedPreferences prefs = await _prefs.future;
    await prefs.setStringList(PrefsKey.SEEN_NOTIFICATION.toString(), ids);
    _readNotifications = ids;
    notifyListeners();
  }
}
