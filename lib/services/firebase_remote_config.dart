import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shuttler/models/driver_config.dart';
import 'package:shuttler/utilities/contants.dart';

class FirebaseRemoteConfig {
  // SINGLETON //

  static final FirebaseRemoteConfig _singleton =
      FirebaseRemoteConfig._internal();

  FirebaseRemoteConfig._internal();

  factory FirebaseRemoteConfig() => _singleton;

  static FirebaseRemoteConfig get instance => _singleton;

  RemoteConfig _remoteConfig;

  // METHODS //

  /// Call this function in the top level of the app
  Future<RemoteConfig> setupRemoteConfig({String appName}) async {
    try {
      _remoteConfig = await RemoteConfig.instance;
      await _remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await _remoteConfig.activateFetched();

      return _remoteConfig;
    } catch (error) {
      return null;
    }
  }

  Future<void> getLocations() async {
    final configValue =
        _remoteConfig.getValue(describeEnum(ConfigParams.LocationConfig));

    print('configValue');
    print(configValue);
    print(configValue.toString());
    print(configValue.asString());
  }

  Future<DriverConfig> getDriverConfig() async {
    final configValue =
        _remoteConfig.getValue(describeEnum(ConfigParams.DriverConfig));

    final DriverConfig driverConfig =
        DriverConfig.fromRemoteConfig(configValue);

    return driverConfig;
  }
}
