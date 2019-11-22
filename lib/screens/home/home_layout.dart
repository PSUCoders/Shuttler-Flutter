import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Home Screen Layout with
/// This Home Layout uses CupertinoTabScaffold due to its fast performance,
/// it also retains the pages' states
class HomeLayout extends StatelessWidget {
  final List<Widget> pages;
  final bool hasUnreadNotification;
  final Function(int) onNavBarTap;
  final TabController tabController;
  final int currentIndex;

  HomeLayout({
    this.pages,
    this.hasUnreadNotification,
    this.onNavBarTap,
    this.tabController,
    this.currentIndex,
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
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: this.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: this.onNavBarTap,
        currentIndex: this.currentIndex,
        items: _buildTabBarItems(),
      ),
    );
  }
}
