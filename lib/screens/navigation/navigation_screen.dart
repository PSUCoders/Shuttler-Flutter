import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shuttler_flutter/screens/navigation/navigation_cupertino.dart';
import 'package:shuttler_flutter/screens/navigation/navigation_material.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static final CameraPosition _kPlattsburgh = CameraPosition(
    target: LatLng(44.7065763, -73.460642),
    zoom: 14.151926040649414,
  );

  Future<void> _goToThePlattsburgh() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPlattsburgh));
  }

  @override
  Widget build(BuildContext context) {
    // List of buttons on the map
    List<Widget> _mapActions = [
      PlatformButton(
        onPressed: () {
          print('Shuttle location pressed');
        },
        color: Colors.white70,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.directions_bus,
          color: Theme.of(context).accentColor,
        ),
      ),
      PlatformButton(
        onPressed: _goToThePlattsburgh,
        color: Colors.white70,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.my_location,
          color: Theme.of(context).accentColor,
        ),
      )
    ];

    if (Platform.isIOS)
      return NavigationCupertino(
        onMapCreated: (controller) {
          // Get Google Maps controller
          try {
            _controller.complete(controller);
          } catch (error) {}
        },
        mapActions: _mapActions,
      );
    else
      return NavigationMaterial(
        onMapCreated: (controller) {
          // Get Google Maps controller
          try {
            _controller.complete(controller);
          } catch (error) {}
        },
        mapActions: _mapActions,
      );
  }
}
