import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shuttler_flutter/providers/device_state.dart';
import 'package:shuttler_flutter/screens/home/home_screen.dart';
import 'package:shuttler_flutter/utilities/theme.dart';

void main() => runApp(Shuttler());

// This widget is the root of your application.
class Shuttler extends StatefulWidget {
  const Shuttler({
    Key key,
  }) : super(key: key);

  @override
  _ShuttlerState createState() => _ShuttlerState();
}

class _ShuttlerState extends State<Shuttler> {
  DeviceState _deviceState;

  @override
  void initState() {
    super.initState();
    _deviceState = DeviceState();
    _deviceState.fetchStates();
  }

  @override
  void dispose() {
    super.dispose();
    // authenticationBloc.dispose();
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.pink,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16, color: Colors.pink),
        hintStyle: TextStyle(fontSize: 16, color: Colors.pink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeviceState>(
      builder: (context) => _deviceState,
      child: PlatformApp(
        debugShowCheckedModeBanner: false,
        title: 'Shuttler',
        ios: (_) => CupertinoAppData(
          theme: ShuttlerTheme.of(context).cupertinoOverrideTheme,
          home: HomeScreen(),
        ),
        android: (_) => MaterialAppData(
          theme: ShuttlerTheme.of(context),
          home: HomeScreen(),
        ),
        // home: HomeScreen(),
      ),
    );
  }
}
