import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Home Screen Layout with Cupertino Style for iOS devices
class HomeCupertino extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navBarItems;
  final bool hasUnreadNotification;

  HomeCupertino({
    this.pages,
    this.navBarItems,
    this.hasUnreadNotification,
  });

  @override
  _HomeCupertinoState createState() => _HomeCupertinoState();
}

class _HomeCupertinoState extends State<HomeCupertino> {
  GoogleMapController mapController;
  CupertinoTabController controller = CupertinoTabController(initialIndex: 1);

  @override
  void initState() {
    super.initState();

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
        onTap: (index) {
          print('tab $index selected');
        },
        currentIndex: 1,
        items: widget.navBarItems,
      ),
      controller: controller,
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(builder: (BuildContext context) {
          return widget.pages[index];
        });
      },
    );
  }
}
