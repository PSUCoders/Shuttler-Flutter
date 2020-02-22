import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLayout extends StatelessWidget {
  DriverLayout({
    Key key,
    this.onLogoutTap,
    this.onOpenSettings,
    this.driverMessage,
    this.isTracking,
    this.onToggleTracking,
    this.loadFailed = false,
  }) : super(key: key);

  final VoidCallback onLogoutTap;
  final Function(bool) onToggleTracking;
  final bool isTracking;
  final String driverMessage;
  final VoidCallback onOpenSettings;
  final bool loadFailed;

  static final CameraPosition _kACC = CameraPosition(
    target: LatLng(44.692939, -73.466752),
    zoom: 14.151926040649414,
  );

  Widget _buildGoogleMap() {
    return GoogleMap(
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          northeast: LatLng(44.720872, -73.431070),
          southwest: LatLng(44.675484, -73.510132),
        ),
      ),
      minMaxZoomPreference: MinMaxZoomPreference(14, 18),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      initialCameraPosition: DriverLayout._kACC,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: loadFailed
                  ? Center(
                      child: Text('Connection to the server failed'),
                    )
                  : Column(
                      children: <Widget>[
                        SwitchListTile(
                          onChanged: this.onToggleTracking,
                          value: this.isTracking,
                          title: Text("Tracking"),
                        ),
                        Divider(thickness: 1, height: 1),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
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
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: <Widget>[
                                _buildGoogleMap(),
                                if (!this.isTracking) ...[
                                  Container(color: Colors.black26),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red[300],
                                        borderRadius:
                                            BorderRadius.circular(360),
                                      ),
                                      child: Text(
                                        'Tracking off',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
