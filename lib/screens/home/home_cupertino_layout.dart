import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Home Screen Layout with Cupertino Style for iOS devices
class HomeCupertinoLayout extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navBarItems;
  final bool hasUnreadNotification;

  HomeCupertinoLayout({
    this.pages,
    this.navBarItems,
    this.hasUnreadNotification,
  });

  @override
  _HomeCupertinoLayoutState createState() => _HomeCupertinoLayoutState();
}

class _HomeCupertinoLayoutState extends State<HomeCupertinoLayout> {
  CupertinoTabController _tabController =
      CupertinoTabController(initialIndex: 1);

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
      controller: _tabController,
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(builder: (BuildContext context) {
          return widget.pages[index];
        });
      },
    );
  }
}
