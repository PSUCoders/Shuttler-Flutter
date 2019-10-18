import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Home Screen Layout with Material Style for Android devices
class HomeMaterial extends StatefulWidget {
  final Widget navigationScreen;
  final Widget notificationScreen;
  final Widget settingScreen;
  final List<BottomNavigationBarItem> navBarItems;

  HomeMaterial({
    this.navigationScreen,
    this.notificationScreen,
    this.settingScreen,
    this.navBarItems,
  });

  @override
  _HomeMaterialState createState() => _HomeMaterialState();
}

class _HomeMaterialState extends State<HomeMaterial>
    with SingleTickerProviderStateMixin {
  GoogleMapController mapController;
  TabController _tabController;
  List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1, // Open Map tab first
    );
    // Setup 3 pages for navigation
    pages = [
      widget.notificationScreen,
      widget.navigationScreen,
      widget.settingScreen,
    ].where(((page) => page != null)).toList(); // filter out any null value
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleNavigationBarTap(int index) {
    _tabController.animateTo(index);

    // Force rebuild bottom navigation bar active item
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabController.index,
          onTap: _handleNavigationBarTap,
          items: widget.navBarItems,
        ),
      ),
    );
  }
}
