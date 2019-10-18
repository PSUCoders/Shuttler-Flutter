import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shuttler_flutter/providers/device_state.dart';

class SettingMaterialLayout extends StatefulWidget {
  const SettingMaterialLayout({
    Key key,
    @required this.deviceState,
  }) : super(key: key);

  final DeviceState deviceState;

  @override
  _SettingMaterialLayoutState createState() => _SettingMaterialLayoutState();
}

class _SettingMaterialLayoutState extends State<SettingMaterialLayout> {
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
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildNotificationToggler(widget.deviceState),
              _buildNotifyPicker(widget.deviceState),
            ],
          )
        ],
      ),
    );
  }
}
