import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/device_state.dart';

/// Setting Screen
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ShuttleStop dropdownValue = ShuttleStop.Campus;

  Widget _buildNotificationToggler(DeviceState deviceState) {
    return ListTile(
      title: Text("Enable Notification"),
      subtitle: Text("Enable option to get notification"),
      trailing: PlatformSwitch(
        onChanged: (bool value) => deviceState.turnNotificationOn(value),
        value: deviceState.isNotificationOn,
      ),
    );
  }

  Widget _buildNotifyPicker(DeviceState deviceState) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text("Notify me when the Shuttler is at"),
          subtitle: Text("In which stop would you like to be notified?"),
        ),
        DropdownButton<ShuttleStop>(
          value: dropdownValue,
          // icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (ShuttleStop newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: ShuttleStop.values
              .map<DropdownMenuItem<ShuttleStop>>((ShuttleStop value) {
            return DropdownMenuItem<ShuttleStop>(
              value: value,
              child: Text(value.toString().split(".")[1]),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceState = Provider.of<DeviceState>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildNotificationToggler(deviceState),
                _buildNotifyPicker(deviceState),
              ],
            )
          ],
        ),
      ),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            PlatformSwitch(
              onChanged: (bool value) => deviceState.turnNotificationOn(value),
              value: deviceState.isNotificationOn,
            )
          ],
        ),
      ),
    );
  }
}
