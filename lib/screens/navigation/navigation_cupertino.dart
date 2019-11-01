import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/providers/map_state.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationCupertino extends StatefulWidget {
  final FutureVoidCallback onMyLocationPress;
  final FutureVoidCallback onShuttleLocationPress;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final List<Widget> mapActions;
  final Function goToDriver;
  final List<LatLng> driverLocations;
  final Stream<Driver> driverStream;
  final String nextStop;

  NavigationCupertino({
    this.onMyLocationPress,
    this.onShuttleLocationPress,
    this.onMapCreated,
    this.onMapTap,
    this.mapActions,
    this.goToDriver,
    this.driverLocations,
    this.driverStream,
    this.nextStop,
  });

  @override
  _NavigationCupertinoState createState() => _NavigationCupertinoState();
}

class _NavigationCupertinoState extends State<NavigationCupertino> {
  var _shuttleIcon;
  bool _hasShuttleIcon = false;

  @override
  void initState() {
    super.initState();
    _getShuttleIcon();
  }

  _getShuttleIcon() async {
    final shuttleIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/icons/ic_shuttle.png",
    );
    setState(() {
      _shuttleIcon = shuttleIcon;
      _hasShuttleIcon = true;
    });
  }

  static final CameraPosition _kPlattsburgh = CameraPosition(
    target: LatLng(44.7065763, -73.460642),
    zoom: 14.151926040649414,
  );

  Align _buildNextStop() {
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
            Text("Next Stop"),
            SizedBox(height: 10),
            // TODO Fix low res image
            Image.asset(
              'assets/icons/ic_navigation.png',
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              "Walmart",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildActions() {
    return Container(
      padding: EdgeInsets.all(20),
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

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      markers: widget.driverLocations
          .map((loc) => Marker(
                icon: _hasShuttleIcon
                    ? _shuttleIcon
                    : BitmapDescriptor.defaultMarker,
                markerId: MarkerId(this.hashCode.toString()),
                position: loc,
              ))
          .toSet(),
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kPlattsburgh,
      onMapCreated: widget.onMapCreated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    print('Map Provider drivers $mapState');
    print(mapState.drivers);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Map'),
      ),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildGoogleMap(),
            _buildActions(),
            _buildNextStop(),
          ],
        ),
      ),
    );
  }
}
