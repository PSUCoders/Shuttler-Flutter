import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/providers/tracking_state.dart';

import 'package:shuttler/screens/home/home_driver_screen_layout.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:location_permissions/location_permissions.dart';

class HomeDriverScreen extends StatefulWidget {
  HomeDriverScreen({Key key}) : super(key: key);

  @override
  _HomeDriverScreenState createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  void _handleLogoutTap() async {
    await Provider.of<AuthState>(context).logout();

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _handleToggleTracking(value) async {
    // TODO
    TrackingState state = Provider.of<TrackingState>(context, listen: false);
    state.toggleTracking();
  }

  void _openSettings() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location permission needed"),
          content: Text("Please allow location access all the time."),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                Navigator.pop(context);
                await LocationPermissions().openAppSettings();
              },
              child: Text(
                'Go to Settings',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TrackingState state = Provider.of<TrackingState>(context);

    if (state.isPermissionDenied) {
      //
      _openSettings();
    }

    return HomeDriverLayout(
      onLogoutTap: _handleLogoutTap,
      onToggleTracking: _handleToggleTracking,
      driverMessage: kDriverHomeMessage,
      isTracking: state.isTracking,
      onOpenSettings: _openSettings,
    );
  }
}
