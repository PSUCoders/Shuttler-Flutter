import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/screens/home/home_cupertino_layout.dart';
import 'package:shuttler/screens/home/home_material_layout.dart';
import 'package:shuttler/screens/navigation/map_screen.dart';
import 'package:shuttler/screens/notification/notification_screen.dart';
import 'package:shuttler/screens/setting/setting_screen.dart';
import 'package:shuttler/providers/map_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);

    final List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[
      // TODO might need to update icons
      BottomNavigationBarItem(
        icon: Stack(
          children: <Widget>[
            Icon(
              Icons.notifications,
            ),
            if (notificationState.hasUnreadNotification)
              Positioned(
                right: 2,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
          ],
        ),
        title: Text('Notification'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map),
        title: Text('Map'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        title: Text('Settings'),
      ),
    ];

    final List<Widget> pages = [
      NotificationScreen(),
      ChangeNotifierProvider<MapState>(
        builder: (_) => MapState(),
        child: MapScreen(),
      ),
      SettingScreen(),
    ];

    if (Platform.isIOS)
      return HomeCupertinoLayout(
        navBarItems: navBarItems,
        pages: pages,
      );
    else
      // Android Layout
      return HomeMaterialLayout(
        navBarItems: navBarItems,
        pages: pages,
      );
  }
}
