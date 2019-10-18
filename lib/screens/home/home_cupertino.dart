import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Home Screen Layout with Cupertino Style for iOS devices
class HomeCupertino extends StatefulWidget {
  final Widget navigationScreen;
  final Widget notificationScreen;
  final Widget settingScreen;
  final List<BottomNavigationBarItem> navBarItems;

  HomeCupertino({
    this.navigationScreen,
    this.notificationScreen,
    this.settingScreen,
    this.navBarItems,
  });

  @override
  _HomeCupertinoState createState() => _HomeCupertinoState();
}

class _HomeCupertinoState extends State<HomeCupertino> {
  GoogleMapController mapController;
  final List<BottomNavigationBarItem> _navBarItems = <BottomNavigationBarItem>[
    // TODO use correct icons
    BottomNavigationBarItem(icon: Icon(Icons.notifications)),
    BottomNavigationBarItem(icon: Icon(Icons.navigation)),
    BottomNavigationBarItem(icon: Icon(Icons.settings)),
  ];
  List<Widget> pages;
  CupertinoTabController controller = CupertinoTabController(initialIndex: 1);

  @override
  void initState() {
    super.initState();

    // Setup 3 pages for navigation
    pages = [
      widget.notificationScreen,
      widget.navigationScreen,
      widget.settingScreen,
    ].where(((page) => page != null)).toList(); // filter out any null value

    // _firebaseMessaging = FirebaseMessaging()
    //   ..configure(onMessage: (message) {
    //     print("on message $message");
    //   }, onLaunch: (message) {
    //     print("on launch $message");
    //   }, onResume: (message) {
    //     print("on resume $message");
    //   });
    // _firebaseMessaging.getToken().then((token) => print("token is: " + token));

    // _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        items: widget.navBarItems ?? _navBarItems,
      ),
      controller: controller,
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return pages[index];
          },
        );
      },
    );
  }
}
