import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/widgets/shuttler_logo.dart';

/// This screen decides which route to go to when launch the app
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  /// Navigate to appropriate route
  _navigate() async {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (await authState.isSignedIn()) {
      if (await authState.isSignedInAsDriver()) {
        Navigator.pushNamedAndRemoveUntil(context, '/driver', (route) => false);
        return;
      }
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      // Need this because iOS hasn't had deep link setup yet
      if (Platform.isIOS) {
        print('ios');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return;
      }

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}
