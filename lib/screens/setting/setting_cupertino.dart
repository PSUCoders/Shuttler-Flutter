import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shuttler_flutter/providers/device_state.dart';
import 'package:shuttler_flutter/utilities/theme.dart';

const double _kDropdownItemHeight = 30.0;

class SettingCupertinoLayout extends StatefulWidget {
  SettingCupertinoLayout({
    Key key,
    @required this.deviceState,
    this.notificationOn,
    this.options,
    this.shuttleStop,
    this.onNotificationChange,
    this.onShuttleStopChange,
    this.pickerItemHeight,
    this.pickerItems,
    this.onCodingHubPress,
  }) : super(key: key);

  final DeviceState deviceState;
  final String shuttleStop;
  final String options;
  final bool notificationOn;
  final Function(bool) onNotificationChange;
  final Function(ShuttleStop) onShuttleStopChange;
  final double pickerItemHeight;
  final List<String> pickerItems;
  final Function onCodingHubPress;

  @override
  _SettingCupertinoLayoutState createState() => _SettingCupertinoLayoutState();
}

class _SettingCupertinoLayoutState extends State<SettingCupertinoLayout> {
  /// Build notification toggler
  Widget _buildNotificationSetting(DeviceState deviceState) {
    return Container(
      child: ListTile(
        title: Text("Notification"),
        subtitle: Text("Enable option to get notification"),
        trailing: PlatformSwitch(
          onChanged: (bool value) => deviceState.turnNotificationOn(value),
          value: deviceState.isNotificationOn,
        ),
      ),
    );
  }

  Widget _buildShuttleStopSetting(DeviceState deviceState) {
    return ListTile(
      title: Text("Shuttle Stop"),
      subtitle: Text("In which stop would you like to be notified?"),
      trailing: CupertinoButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () {
          _showStopPicker(deviceState);
        },
        child: Text(widget.deviceState.shuttleStop),
      ),
    );
  }

  void _showStopPicker(DeviceState deviceState) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: (ShuttleStop.values.length + 2) * _kDropdownItemHeight,
          padding: EdgeInsets.all(0),
          // // Not sure if this is needed or not
          // child: GestureDetector(
          //   // Blocks taps from propagating to the modal sheet and popping.
          //   onTap: () {},
          child: SafeArea(
            top: false,
            bottom: false,
            child: CupertinoPicker(
              itemExtent: _kDropdownItemHeight,
              looping: true,
              onSelectedItemChanged: (index) {
                print('item $index is picked');
                print(ShuttleStop.values[index]);

                widget.deviceState.changeShuttleStop(ShuttleStop.values[index]);
              },
              children: widget.pickerItems.map((stop) => Text(stop)).toList(),
            ),
          ),
          // ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildNotificationSetting(widget.deviceState),
                _buildShuttleStopSetting(widget.deviceState),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Developed with ❤️ by '),
                GestureDetector(
                  onTap: widget.onCodingHubPress,
                  child: Text(
                    'Coding Hub',
                    style: TextStyle(
                      color: ShuttlerTheme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
