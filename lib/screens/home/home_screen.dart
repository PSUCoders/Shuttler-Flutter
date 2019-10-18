import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/notification_state.dart';

import 'package:shuttler_flutter/screens/home/home_cupertino.dart';
import 'package:shuttler_flutter/screens/home/home_material.dart';
import 'package:shuttler_flutter/screens/navigation/navigation_screen.dart';
import 'package:shuttler_flutter/screens/notification/notification_screen.dart';
import 'package:shuttler_flutter/screens/setting/setting_screen.dart';
import 'package:shuttler_flutter/providers/map_provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapState _mapProvider;
  NotificationState _notificationState;

  @override
  void initState() {
    super.initState();
    _mapProvider = MapState();
    _notificationState = NotificationState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('home screen build called');
    final List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[
      // TODO use correct icons
      BottomNavigationBarItem(
        icon: Icon(Icons.notifications),
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

    Widget home;

    Widget notificationScreen = ChangeNotifierProvider<NotificationState>(
      builder: (_) => NotificationState(),
      child: NotificationScreen(),
    );

    Widget navigationScreen = ChangeNotifierProvider<MapState>(
      builder: (_) => MapState(),
      child: NavigationScreen(),
    );

    Widget settingScreen = SettingScreen();

    if (Platform.isIOS)
      home = HomeCupertino(
        navBarItems: navBarItems,
        navigationScreen: navigationScreen,
        settingScreen: settingScreen,
        notificationScreen: notificationScreen,
      );
    else
      // Android Layout
      home = HomeMaterial(
        navBarItems: navBarItems,
        navigationScreen: navigationScreen,
        settingScreen: settingScreen,
        notificationScreen: notificationScreen,
      );

    return home;
  }
}
