import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/providers/map_state.dart';
import 'package:shuttler/screens/navigation/map_layout.dart';
import 'package:shuttler/widgets/circle_button.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin<MapScreen>, WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final mapState = Provider.of<MapState>(context, listen: false);

    if (state == AppLifecycleState.resumed) {
      mapState.resumeSubscriptions();
    } else if (state == AppLifecycleState.paused) {
      mapState.pauseSubscriptions();
    }
  }

  @override
  void dispose() {
    print('MapScreen disposing...');
    // stop listening to didChangeAppLifecycleState
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  // Prevent the map from being killed
  bool get wantKeepAlive => true;

  _goToLocation(LatLng latLng) async {
    print('go to location called');
    print(latLng);
    final GoogleMapController controller = await _controller.future;
    if (latLng != null) {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 15,
      )));
    } else {
      print('latLng is null');
    }
  }

  _goToCurrentLocation() async {
    print('go to current location called');

    final GoogleMapController controller = await _controller.future;
    final location = await Provider.of<MapState>(context).getCurrentLocation();

    print('location $location');
    if (location != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: location,
        zoom: 14,
      )));
    }
  }

  _handleMapCreated(GoogleMapController controller) {
    // Get Google Maps controller
    try {
      _controller.complete(controller);
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    print('nav screen rebuild...');
    final mapState = Provider.of<MapState>(context);

    // List of buttons on the map
    List<Widget> _mapActions = [
      CircleButton(
        onPressed: () => _goToLocation(mapState.focusDriverLocation),
        icon: Icons.directions_bus,
      ),
      CircleButton(
        onPressed: _goToCurrentLocation,
        icon: Icons.my_location,
      ),
    ];

    super.build(context);

    // Show loading when data is not ready
    if (!mapState.hasData) return Center(child: CircularProgressIndicator());

    List<Driver> driverLocations = mapState.allDriversLocations;

    if (driverLocations != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Map')),
        body: mapState.hasActiveDriver
            ? MapLayout(
                onMapCreated: _handleMapCreated,
                mapActions: _mapActions,
                driverLocations: driverLocations,
              )
            : Center(child: Text("No shuttle is currently being tracked")),
      );
    } else {
      return Center(
        child: Text("Cannot connect to the server"),
      );
    }
  }
}
