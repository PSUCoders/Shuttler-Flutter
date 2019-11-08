import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler/models/driver.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Map Screen
class MapLayout extends StatefulWidget {
  final FutureVoidCallback onMyLocationPress;
  final FutureVoidCallback onShuttleLocationPress;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final List<Widget> mapActions;
  final List<Driver> driverLocations;
  final bool showNextStop;

  MapLayout({
    this.onMyLocationPress,
    this.onShuttleLocationPress,
    this.onMapTap,
    this.mapActions,
    this.onMapCreated,
    this.driverLocations,
    this.showNextStop = false,
  });

  @override
  _MapLayoutState createState() => _MapLayoutState();
}

class _MapLayoutState extends State<MapLayout> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _shuttleIcon;
  bool _hasShuttleIcon = false;

  @override
  void initState() {
    super.initState();
    _getShuttleIcon();
  }

  _getShuttleIcon() async {
    final shuttleIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: new Size(200, 200),devicePixelRatio: 3.0),
      "assets/icons/ic_shuttle.png",
    );
    setState(() {
      _shuttleIcon = shuttleIcon;
      _hasShuttleIcon = true;
    });
  }

  static final CameraPosition _kACC = CameraPosition(
    target: LatLng(44.692939, -73.466752),
    zoom: 14.151926040649414,
  );

  Widget _buildGoogleMap() {
    return GoogleMap(
      markers: widget.driverLocations
          .map((driver) => Marker(
                // TODO fix super small icon
                icon: _hasShuttleIcon
                    ? _shuttleIcon
                    : BitmapDescriptor.defaultMarker,
                markerId: MarkerId(driver.id),
                position: driver.latLng,
                rotation: driver.direction,
              ))
          .toSet(),
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          northeast: LatLng(44.720872, -73.431070),
          southwest: LatLng(44.675484, -73.510132),
        ),
      ),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kACC,
      onMapCreated: (GoogleMapController controller) {
        try {
          _controller.complete(controller);
          widget.onMapCreated(controller);
        } catch (error) {
          print(error);
        }
      },
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          /// Add a space of 10 in between each element
          widget.mapActions.length * 2 - 1,
          (index) {
            if (index.isEven)
              return widget.mapActions[index ~/ 2];
            else
              return SizedBox(height: 10);
          },
        ),
      ),
    );
  }

  Widget _buildNextStop() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Next Stop",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 10),
            // TODO update this asset to be black
            Image.asset(
              'assets/icons/ic_navigation.png',
              color: Colors.black87,
            ),
            SizedBox(height: 10),
            Text(
              "Walmart",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          _buildGoogleMap(),
          _buildActions(),
          if (widget.showNextStop) _buildNextStop(),
        ],
      ),
    );
  }
}
