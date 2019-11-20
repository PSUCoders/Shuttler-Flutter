import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/screens/home/home_layout.dart';
import 'package:shuttler/screens/map/map_screen.dart';
import 'package:shuttler/screens/notification/notification_screen.dart';
import 'package:shuttler/screens/setting/setting_screen.dart';
import 'package:shuttler/providers/map_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> pages;
  CupertinoTabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = CupertinoTabController(initialIndex: 1);

    pages = [
      NotificationScreen(),
      ChangeNotifierProvider<MapState>(
        builder: (_) => MapState(),
        child: MapScreen(),
      ),
      SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(context);

    return HomeLayout(
      pages: pages,
      hasUnreadNotification: notificationState.hasUnreadNotification,
      tabController: _tabController,
    );
  }
}
