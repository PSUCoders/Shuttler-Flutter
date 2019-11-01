import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler/utilities/theme.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationMaterial extends StatefulWidget {
  final FutureVoidCallback onMyLocationPress;
  final FutureVoidCallback onShuttleLocationPress;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final List<Widget> mapActions;
  final List<LatLng> driverLocations;

  NavigationMaterial({
    this.onMyLocationPress,
    this.onShuttleLocationPress,
    this.onMapTap,
    this.mapActions,
    this.onMapCreated,
    this.driverLocations,
  });

  @override
  _NavigationMaterialState createState() => _NavigationMaterialState();
}

class _NavigationMaterialState extends State<NavigationMaterial> {
  Completer<GoogleMapController> _controller = Completer();
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

  Widget _buildGoogleMap() {
    return GoogleMap(
      markers: widget.driverLocations
          .map((loc) => Marker(
                // TODO fix super small icon
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
            Image.asset('assets/icons/ic_navigation.png'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: SafeArea(
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
