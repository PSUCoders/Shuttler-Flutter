import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class DriverConfig {
  /// Emails of drivers who are active
  List<String> activeEmails = [];

  /// Emails of drivers that can login
  List<String> emails = [];

  List<DriverRules> driverRules = [];

  DriverConfig.fromRemoteConfig(RemoteConfigValue value) {
    try {
      if (value.source != ValueSource.valueStatic) {
        List<dynamic> config = json.decode(value.asString());

        driverRules = config.map((item) {
          final rule = DriverRules(item);

          if (rule.active) activeEmails.add(rule.email);
          emails.add(rule.email);
          driverRules.add(rule);

          return rule;
        }).toList();
      }
    } catch (error) {
      print('error in DriverConfig.fromRemoteConfig');
      print(error);
    }
  }
}

class DriverRules {
  bool active;
  String email;

  DriverRules(Map<String, dynamic> data) {
    active = data['active'];
    email = data['email'];
  }

  @override
  String toString() {
    return """driver $email is active $active""";
  }
}
