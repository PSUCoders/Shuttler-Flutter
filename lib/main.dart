import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/app.dart';
import 'package:shuttler/providers/notification_state.dart';

void main() => runApp(ProviderWrapper());

class ProviderWrapper extends StatefulWidget {
  const ProviderWrapper({
    Key key,
  }) : super(key: key);

  @override
  _ProviderWrapperState createState() => _ProviderWrapperState();
}

class _ProviderWrapperState extends State<ProviderWrapper> {
  @override
  Widget build(BuildContext context) {
    print('main.dart');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceState>(
          builder: (context) => DeviceState(),
        ),
        ChangeNotifierProvider<AuthState>(
          builder: (context) => AuthState(),
        ),
        ChangeNotifierProvider<NotificationState>(
          builder: (context) => NotificationState(),
        )
      ],
      child: Shuttler(),
    );
  }
}
