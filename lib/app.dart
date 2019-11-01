import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/device_state.dart';
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
    print('is sign in ${authState.isSignIn}');
    print("hasData? ${deviceState.hasData}");

    /// TODO show loading screen
    /// may be show Coding Hub logo

    return PlatformApp(
      debugShowCheckedModeBanner: false,
      title: 'Shuttler',
      ios: (_) => CupertinoAppData(
        theme: ShuttlerTheme.of(context).cupertinoOverrideTheme,
      ),
      android: (_) => MaterialAppData(
        theme: ShuttlerTheme.of(context),
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: authState.authStream(),
        builder: (context, snapshot) {
          print("user id: ${snapshot.data?.uid}");

          // if (snapshot.data == null) {
          //   return SignInScreen();
          // }

          // if (!snapshot.hasData) {
          //   return Container(
          //     color: Colors.white,
          //     child: Center(child: CircularProgressIndicator()),
          //   );
          // }

          return HomeScreen();
        },
      ),
    );
  }
}
