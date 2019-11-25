import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/providers/tracking_state.dart';
import 'package:shuttler/screens/home/home_driver_screen.dart';
import 'package:shuttler/screens/sign_in/pre_sign_in_screen.dart';
import 'package:shuttler/screens/redirect_screen.dart';
import 'package:shuttler/utilities/theme.dart';
import 'package:shuttler/screens/home/home_screen.dart';

class ShuttlerApp extends StatefulWidget {
  const ShuttlerApp({
    Key key,
  }) : super(key: key);

  @override
  _ShuttlerAppState createState() => _ShuttlerAppState();
}

class _ShuttlerAppState extends State<ShuttlerApp> {
  Map<String, Widget Function(BuildContext)> routes;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    routes = {
      '/': (context) => RedirectScreen(),
      '/home': (context) => ChangeNotifierProvider<NotificationState>(
            builder: (context) => NotificationState(),
            child: HomeScreen(),
          ),
      '/driver': (context) => ChangeNotifierProvider<TrackingState>(
            builder: (context) => TrackingState(),
            child: HomeDriverScreen(),
          ),
      '/login': (context) => PreSignInScreen(),
    };
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();

    return remoteConfig;
  }

  @override
  Widget build(BuildContext context) {
    print('App building...');

    return FutureBuilder<RemoteConfig>(
      future: setupRemoteConfig(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shuttler',
          theme: ShuttlerTheme.of(context),
          routes: this.routes,
          initialRoute: '/',
          builder: (context, widget) {
            if (!snapshot.hasData) return Container(color: Colors.white);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider<DeviceState>(
                  builder: (context) => DeviceState(),
                ),
                ChangeNotifierProvider<AuthState>(
                  builder: (context) => AuthState(),
                ),
              ],
              child: widget,
            );
          },
        );
      },
    );
  }
}
