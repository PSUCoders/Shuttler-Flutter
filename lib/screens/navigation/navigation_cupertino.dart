import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/models/driver.dart';
import 'package:shuttler_flutter/providers/map_provider.dart';

typedef FutureVoidCallback = Future<void> Function();

/// Navigation Screen
class NavigationCupertino extends StatefulWidget {
  final FutureVoidCallback onMyLocationPress;
  final FutureVoidCallback onShuttleLocationPress;
  final Function(GoogleMapController) onMapCreated;
  final Function(LatLng) onMapTap;
  final List<Widget> mapActions;

  NavigationCupertino({
    this.onMyLocationPress,
    this.onShuttleLocationPress,
    this.onMapCreated,
    this.onMapTap,
    this.mapActions,
  });

  @override
  _NavigationCupertinoState createState() => _NavigationCupertinoState();
}

class _NavigationCupertinoState extends State<NavigationCupertino> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kPlattsburgh = CameraPosition(
    // bearing: 192.8334901395799,
    target: LatLng(44.7065763, -73.460642),
    zoom: 14.151926040649414,
  );

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
            GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kPlattsburgh,
              onMapCreated: (GoogleMapController controller) {
                try {
                  _controller.complete(controller);
                } catch (error) {
                  print(error);
                }

                /// Pass controller to parent in the widget tree
                widget.onMapCreated(controller);
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
                // alignment: Alignment.topCenter,
                child: Text('test'),
              ),
            ),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
