import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shuttler/providers/auth_state.dart';
import 'package:shuttler/providers/device_state.dart';
import 'package:shuttler/providers/notification_state.dart';
import 'package:shuttler/providers/tracking_state.dart';
import 'package:shuttler/screens/driver/driver_screen.dart';
import 'package:shuttler/screens/sign_in/pre_sign_in_screen.dart';
import 'package:shuttler/screens/redirect_screen.dart';
import 'package:shuttler/services/firebase_remote_config.dart';
import 'package:shuttler/utilities/contants.dart';
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
  bool _firebaseConfigured = false;

  FirebaseApp app;
  FirebaseApp app2;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    routes = {
      '/': (context) => RedirectScreen(),
      '/home': (context) => ChangeNotifierProvider<NotificationState>(
            create: (context) => NotificationState(),
            child: HomeScreen(),
          ),
      '/driver': (context) => ChangeNotifierProvider<TrackingState>(
            create: (context) => TrackingState(),
            child: DriverScreen(),
          ),
      '/login': (context) => PreSignInScreen(),
    };

    _configure().then((onValue) {
      // Firestore(app: FirebaseApp(name: FirebaseAppName.cas))
      //     .collection('drivers')
      //     .getDocuments()
      //     .then((data) {
      //   data.documents.forEach((doc) {
      //     print(doc.documentID);
      //   });
      // });
    });
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    final defaults = <String, dynamic>{'welcome': 'default welcome'};
    await remoteConfig.setDefaults(defaults);

    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();

    return remoteConfig;
  }

  Future<void> _configure() async {
    final apps0 = await FirebaseApp.allApps();
    print('all apps $apps0');

    print('env ${DotEnv().env}');

    // app = await FirebaseApp.configure(
    //   name: FirebaseAppName.cas,
    //   options: FirebaseOptions(
    //     googleAppID: DotEnv().env['GOOGLE_APP_ID'],
    //     gcmSenderID: DotEnv().env['GCM_SENDER_ID'],
    //     apiKey: DotEnv().env['FIREBASE_API_KEY'],
    //     androidClientID: DotEnv().env['ANDROID_CLIENT_ID'],
    //     projectID: DotEnv().env['PROJECT_ID'],
    //     clientID: DotEnv().env['CLIENT_ID'],
    //     bundleID: DotEnv().env['BUNDLE_ID'],
    //     databaseURL: DotEnv().env['DATABASE_URL'],
    //     storageBucket: DotEnv().env['STORAGE_BUCKET'],
    //   ),
    // );

    // app = await FirebaseApp.configure(
    //   name: FirebaseAppName.cas,
    //   options: FirebaseOptions(
    //     googleAppID: '1:932816794115:ios:1dd59334ad06d3f89c1436',
    //     gcmSenderID: '932816794115',
    //     apiKey: 'AIzaSyAtRhmrzboTi5-xrjyy5SX1hnYaHZ4TOtY',
    //   ),
    // );

    // final apps = await FirebaseApp.allApps();

    // print('all apps $apps');

    // app2 = await FirebaseApp.configure(
    //   name: FirebaseAppName.codinghub,
    //   options: FirebaseOptions(
    //     googleAppID: '1:571374342123:android:ef422395de0f5c4db8d3ae',
    //     gcmSenderID: '571374342123',
    //     apiKey: 'AIzaSyD-sBwoMTBx46wIgRw_cMT9krrvx7z3MAY',
    //     androidClientID:
    //         '571374342123-r5drd5t87rqiilcs8j1uvr1om1vt0kdp.apps.googleusercontent.com',
    //     projectID: 'shuttler-p001',
    //     clientID:
    //         '571374342123-r5drd5t87rqiilcs8j1uvr1om1vt0kdp.apps.googleusercontent.com',
    //   ),
    // );

    // assert(app != null);
    // print('Configured $app');

    setState(() {
      _firebaseConfigured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('App building...');

    return FutureBuilder<RemoteConfig>(
      future: FirebaseRemoteConfig.instance.setupRemoteConfig(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shuttler',
          theme: ShuttlerTheme.of(context),
          routes: this.routes,
          initialRoute: '/',
          builder: (context, widget) {
            print('FirebaseRemoteConfig hasData ${snapshot.hasData}');
            if (!snapshot.hasData) return Container(color: Colors.white);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider<DeviceState>(
                  create: (context) => DeviceState(),
                ),
                ChangeNotifierProvider<AuthState>(
                  create: (context) => AuthState(appName: FirebaseAppName.cas),
                  // create: (context) => AuthState(appName: FirebaseAppName.cas),
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
