import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Home Screen Layout with Material Style for Android devices
class HomeMaterialLayout extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navBarItems;

  HomeMaterialLayout({
    this.pages,
    this.navBarItems,
  });

  @override
  _HomeMaterialLayoutState createState() => _HomeMaterialLayoutState();
}

class _HomeMaterialLayoutState extends State<HomeMaterialLayout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 1, // Open Map tab first
    );
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
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabController.index,
        onTap: _handleNavigationBarTap,
        items: widget.navBarItems,
      ),
    );
  }
}
