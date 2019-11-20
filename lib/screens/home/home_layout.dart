import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Home Screen Layout with
/// This Home Layout uses CupertinoTabScaffold due to its fast performance,
/// it also retains the pages' states
class HomeLayout extends StatelessWidget {
  final List<Widget> pages;
  final bool hasUnreadNotification;
  final CupertinoTabController tabController;
  final Function(int) onTabBarTab;

  HomeLayout({
    this.pages,
    this.hasUnreadNotification,
    this.tabController,
    this.onTabBarTab,
  });

  List<BottomNavigationBarItem> _buildTabBarItems() {
    return <BottomNavigationBarItem>[
      // TODO might need to update icons
      BottomNavigationBarItem(
        icon: Stack(
          children: <Widget>[
            Icon(Icons.notifications),
            if (this.hasUnreadNotification)
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
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: this.tabController,
      tabBar: CupertinoTabBar(
        onTap: this.onTabBarTab,
        items: _buildTabBarItems(),
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) => this.pages[index],
        );
      },
    );
  }
}
