import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationMaterial extends StatefulWidget {
  final FutureVoidCallback onMyLocationPress;
  final FutureVoidCallback onShuttleLocationPress;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final List<Widget> mapActions;

  NavigationMaterial({
    this.onMyLocationPress,
    this.onShuttleLocationPress,
    this.onMapTap,
    this.mapActions,
    this.onMapCreated,
  });

  @override
  _NavigationMaterialState createState() => _NavigationMaterialState();
}

class _NavigationMaterialState extends State<NavigationMaterial> {
  Completer<GoogleMapController> _controller = Completer();
  Widget map;

  @override
  void initState() {
    super.initState();
    map = GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        try {
          _controller.complete(controller);
          widget.onMapCreated(controller);
          setState(() {});
        } catch (error) {
          print(error);
        }
      },
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // if (!_controller.isCompleted)
            //   Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // if (_controller.isCompleted)
            map,
            // GoogleMap(
            //   mapType: MapType.normal,
            //   myLocationButtonEnabled: false,
            //   initialCameraPosition: _kGooglePlex,
            //   onMapCreated: (GoogleMapController controller) {
            //     try {
            //       _controller.complete(controller);
            //       widget.onMapCreated(controller);
            //     } catch (error) {
            //       print(error);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
