import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/screens/sign_in/pre_sign_in_screen.dart';
import 'package:shuttler/screens/splash_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    print('App building...');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeviceState>(
          builder: (context) => DeviceState(),
        ),
        ChangeNotifierProvider<AuthState>(
          builder: (context) => AuthState(),
        ),
        ChangeNotifierProvider<NotificationState>(
          builder: (context) => NotificationState(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shuttler',
        theme: ShuttlerTheme.of(context),
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => PreSignInScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
