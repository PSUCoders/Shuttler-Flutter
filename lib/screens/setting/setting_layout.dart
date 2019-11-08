import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:shuttler/utilities/theme.dart';

class SettingLayout extends StatelessWidget {
  const SettingLayout({
    Key key,
    @required this.onCodingHubPress,
    this.onLogoutPress,
    this.currentStop,
    this.notificationOn,
    this.onShuttleStopChange,
    this.onNotificationChange,
  }) : super(key: key);

  final Function onCodingHubPress;
  final Function onLogoutPress;
  final ShuttleStop currentStop;
  final Function(ShuttleStop) onShuttleStopChange;
  final Function(bool) onNotificationChange;
  final bool notificationOn;

  Widget _buildNotificationToggler(context) {
    return ListTile(
      title: Text("Notification"),
      subtitle: Text("Enable option to get notification"),
      trailing: PlatformSwitch(
        onChanged: this.onNotificationChange,
        value: this.notificationOn,
        activeColor: ShuttlerTheme.of(context).accentColor,
      ),
    );
  }

  Widget _buildNotifyPicker(context) {
    return ListTile(
      title: Text("Shuttle Stop"),
      subtitle: Text("You will be notified when the shuttle is near"),
      trailing: DropdownButton<ShuttleStop>(
        value: this.currentStop,
        iconSize: 0,
        elevation: 16,
        underline: Container(color: Colors.transparent),
        style: TextStyle(
          color: ShuttlerTheme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
        // disabledHint: Text(describeEnum(this.currentStop)),
        hint: Text(describeEnum(this.currentStop)),
        onChanged: this.notificationOn ? this.onShuttleStopChange : null,
        items: ShuttleStop.values
            .map<DropdownMenuItem<ShuttleStop>>(
                (ShuttleStop value) => DropdownMenuItem<ShuttleStop>(
                      value: value,
                      child: Text(describeEnum(value).trim()),
                    ))
            .toList(),
      ),
    );
  }

  Widget _buildFooterText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
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

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.pink,
        onPressed: this.onLogoutPress,
        child: Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _buildNotificationToggler(context),
                    _buildNotifyPicker(context),
                    if (!Platform.isIOS) _buildLogoutButton(),
                  ],
                ),
              ],
            ),
          ),
          _buildFooterText(context)
        ],
      ),
    );
  }
}
