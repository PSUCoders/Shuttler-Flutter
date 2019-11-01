import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/theme.dart';

const double _kDropdownItemHeight = 30.0;

class SettingCupertinoLayout extends StatelessWidget {
  SettingCupertinoLayout({
    Key key,
    this.notificationOn,
    this.options,
    this.shuttleStop,
    this.onNotificationChange,
    this.onShuttleStopChange,
    this.pickerItemHeight,
    this.pickerItems,
    this.onCodingHubPress,
  }) : super(key: key);

  final String shuttleStop;
  final String options;
  final bool notificationOn;
  final Function(bool) onNotificationChange;
  final Function(ShuttleStop) onShuttleStopChange;
  final double pickerItemHeight;
  final List<String> pickerItems;
  final Function onCodingHubPress;

  void _showStopPicker(context) {
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
              onSelectedItemChanged: (index) =>
                  this.onShuttleStopChange(ShuttleStop.values[index]),
              children: this.pickerItems.map((stop) => Text(stop)).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Build notification toggler
  Widget _buildNotificationSetting() {
    return Container(
      child: ListTile(
        title: Text("Notification"),
        subtitle: Text("Enable option to get notification"),
        trailing: PlatformSwitch(
          onChanged: this.onNotificationChange,
          value: this.notificationOn,
        ),
      ),
    );
  }

  Widget _buildShuttleStopSetting(context) {
    return ListTile(
      title: Text("Shuttle Stop"),
      subtitle: Text("In which stop would you like to be notified?"),
      trailing: CupertinoButton(
        padding: EdgeInsets.only(right: 5),
        onPressed: () => _showStopPicker(context),
        child: Text(this.shuttleStop),
      ),
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text('Developed with ❤️ by '),
          GestureDetector(
            onTap: this.onCodingHubPress,
            child: Text(
              'Coding Hub',
              style: TextStyle(
                color: ShuttlerTheme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building cupertino setting...');

    return SafeArea(
      top: false,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildNotificationSetting(),
                _buildShuttleStopSetting(context),
              ],
            ),
          ),
          _buildFooterText(context)
        ],
      ),
    );
  }
}
