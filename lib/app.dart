import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/screens/sign_in/pre_sign_in_screen.dart';
import 'package:shuttler/utilities/theme.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/screens/home/home_screen.dart';

class Shuttler extends StatefulWidget {
  const Shuttler({
    Key key,
  }) : super(key: key);

  @override
  _ShuttlerState createState() => _ShuttlerState();
}

class _ShuttlerState extends State<Shuttler> {
  @override
  Widget build(BuildContext context) {
    final deviceState = Provider.of<DeviceState>(context);
    final AuthState authState = Provider.of<AuthState>(context);

    /// TODO show loading screen
    /// may be show Coding Hub logo

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shuttler',
      theme: ShuttlerTheme.of(context),
      home: StreamBuilder<FirebaseUser>(
        stream: authState.authStream(),
        builder: (context, snapshot) {
          if (Platform.isAndroid) {
            if (snapshot.data == null) {
              return PreSignInScreen();
            }

            if (!snapshot.hasData) {
              return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }
          return HomeScreen();
        },
      ),
    );
  }
}
