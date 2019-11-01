import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shuttler/models/driver.dart';
import 'package:shuttler/providers/map_state.dart';
import 'package:shuttler/screens/navigation/navigation_cupertino.dart';
import 'package:shuttler/screens/navigation/navigation_material.dart';
import 'package:shuttler/utilities/theme.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with
        AutomaticKeepAliveClientMixin<NavigationScreen>,
        WidgetsBindingObserver {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print('nav screen disposing...');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<MapState>(context)..resumeSubscriptions();
    } else if (state == AppLifecycleState.paused) {
      Provider.of<MapState>(context)..pauseSubscriptions();
    }
  }

  @override
  // Prevent the map from being killed
  bool get wantKeepAlive => true;

  static final CameraPosition _kPlattsburgh = CameraPosition(
    target: LatLng(44.7065763, -73.460642),
    zoom: 14.151926040649414,
  );

  Future<void> _goToThePlattsburgh() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPlattsburgh));
  }

  _goToLocation(LatLng latLng) async {
    print('go to location called');
    print(latLng);
    final GoogleMapController controller = await _controller.future;
    if (latLng != null) {
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 14.151926040649414,
      )));
    } else {
      print('latLng is null');
    }
  }

  _goToCurrentLocation() async {
    print('go to current location called');

    final GoogleMapController controller = await _controller.future;
    final location = await Provider.of<MapState>(context).getCurrentLocation();

    if (location != null) {
      print('location $location');
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: location,
        zoom: 14.151926040649414,
      )));
    } else {
      print('location is null');
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
      PlatformButton(
        androidFlat: (_) => MaterialFlatButtonData(
          // onPressed: () {},
          color: Colors.white70,
          padding: EdgeInsets.all(10),
        ),
        onPressed: () => _goToLocation(mapState.driverLocation),
        color: Colors.white70,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.directions_bus,
          color: ShuttlerTheme.of(context).accentColor,
        ),
      ),
      PlatformButton(
        androidFlat: (_) => MaterialFlatButtonData(
          // onPressed: () {},
          color: Colors.white70,
          padding: EdgeInsets.all(10),
        ),
        onPressed: _goToCurrentLocation,
        color: Colors.white70,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.my_location,
          color: ShuttlerTheme.of(context).accentColor,
        ),
      )
    ];

    super.build(context);

    // Show loading when data is not ready
    if (!mapState.hasData) return Center(child: CircularProgressIndicator());

    return StreamBuilder<Driver>(
      stream: mapState.getDriverStream(mapState.drivers.first.id),
      builder: (context, driver) {
        if (!driver.hasData) return Center(child: CircularProgressIndicator());

        if (Platform.isIOS) {
          return NavigationCupertino(
            onMapCreated: _handleMapCreated,
            mapActions: _mapActions,
            goToDriver: () => _goToLocation(driver.data.latLng),
            driverLocations: [driver.data.latLng],
            nextStop: mapState.nextStop,
          );
        }

        return NavigationMaterial(
          onMapCreated: _handleMapCreated,
          mapActions: _mapActions,
          driverLocations: [driver.data.latLng],
        );
      },
    );
  }
}
