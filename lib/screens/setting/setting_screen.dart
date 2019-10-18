import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/device_state.dart';
import 'package:shuttler_flutter/screens/setting/setting_cupertino.dart';
import 'package:shuttler_flutter/screens/setting/setting_material.dart';
import 'package:url_launcher/url_launcher.dart';

const double _kDropdownItemHeight = 30.0;

/// Setting Screen
class SettingScreen extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    final deviceState = Provider.of<DeviceState>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Settings'),
      ),
      android: (_) => MaterialScaffoldData(
        body: SettingMaterialLayout(deviceState: deviceState),
      ),
      ios: (_) => CupertinoPageScaffoldData(
        body: SettingCupertinoLayout(
          deviceState: deviceState,
          onCodingHubPress: _handleCodingHubPress,
          onNotificationChange: deviceState.turnNotificationOn,
          onShuttleStopChange: deviceState.changeShuttleStop,
          pickerItemHeight: _kDropdownItemHeight,
          pickerItems: ShuttleStop.values
              .map((stop) => stop.toString().split('.')[1])
              .toList(),
        ),
      ),
    );
  }
}
