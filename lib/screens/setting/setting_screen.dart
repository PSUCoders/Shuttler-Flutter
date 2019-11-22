import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/screens/setting/setting_layout.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/providers/auth_state.dart';

const double _kDropdownItemHeight = 30.0;

/// Setting Screen
class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ShuttleStop dropdownValue = ShuttleStop.Campus;

  List<Widget> _dropDownItems = [
    Text('item 1'),
    Text('item 2'),
    Text('item 3'),
  ];

  _handleCodingHubPress() async {
    const url = 'https://coding-hub.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _handleLogout() async {
    final authState = Provider.of<AuthState>(context);
    await authState.logout();

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceState = Provider.of<DeviceState>(context);

    print("current stop: ${deviceState.shuttleStop}");

    if (!deviceState.hasData) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SettingLayout(
        currentStop: deviceState.shuttleStop,
        notificationOn: deviceState.isNotificationOn,
        onCodingHubPress: _handleCodingHubPress,
        onLogoutPress: _handleLogout,
        onShuttleStopChange: deviceState.changeShuttleStop,
        onNotificationChange: deviceState.turnNotificationOn,
      ),
    );
  }
}
