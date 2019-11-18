import 'package:flutter/material.dart';

class HomeDriverLayout extends StatelessWidget {
  HomeDriverLayout({
    Key key,
    this.onLogoutTap,
    this.onOpenSettings,
    this.driverMessage,
    this.isTracking,
    this.onToggleTracking,
  }) : super(key: key);

  final VoidCallback onLogoutTap;
  final Function(bool) onToggleTracking;
  final bool isTracking;
  final String driverMessage;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SwitchListTile(
              onChanged: this.onToggleTracking,
              value: this.isTracking,
              title: Text("Tracking"),
            ),
            Expanded(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          this.driverMessage,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: FlatButton(
            //     onPressed: this.onOpenSettings,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(360),
            //     ),
            //     color: Theme.of(context).primaryColor,
            //     child: Text("Open Setting"),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FlatButton(
                onPressed: this.onLogoutTap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ),
                color: Theme.of(context).primaryColor,
                child: Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
