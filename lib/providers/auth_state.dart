import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/models/driver_config.dart';
import 'package:shuttler/utilities/contants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// CONSTANTS
final String _signInWithEmailLinkUrl = "https://shuttler.page.link/verifyEmail";

/// Store all settings to device memory
class AuthState extends ChangeNotifier {
  bool _hasData;
  bool _emailSent;
  bool _isDriver;
  String _errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Completer<SharedPreferences> _prefs = Completer();
  Completer<RemoteConfig> _remoteConfigs = Completer();

  AuthState() {
    // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));

    // Get RemoteConfigs
    RemoteConfig.instance.then((configs) => _remoteConfigs.complete(configs));

    fetchStates();
    _initDynamicLinks();
  }

  // GETTERS //

  bool get hasData => _hasData ?? false;

  bool get emailSent => _emailSent ?? false;

  bool get isDriver => _isDriver ?? false;

  String get errorMessage => _errorMessage ?? "";

  // PRIVATE METHODS //

  Future<dynamic> _handleDynamicLinks(
      PendingDynamicLinkData dynamicLink) async {
    SharedPreferences prefs = await _prefs.future;

    final Uri deepLink = dynamicLink?.link;
    print('deepLink: $deepLink');

    if (deepLink != null) {
      final isSignInWithEmailLink =
          await _auth.isSignInWithEmailLink(deepLink.toString());

      print('deeplink is SignInWithEmailLink $isSignInWithEmailLink');

      if (isSignInWithEmailLink) {
        try {
          // check user email match local storage
          final email = prefs.getString(PrefsKey.EMAIL.toString());

          // if (email == null) {
          //   // TODO handle
          //   return;
          // }

          print('signing with email link...');
          final tempAuthResult = await _auth.signInWithEmailAndLink(
            email: email,
            link: deepLink.toString(),
          );

          // Authenticate successfully
          prefs.setBool(PrefsKey.IS_SIGN_IN.toString(), true);

          // Delete user due to SUNY Plattsburgh IT requirement
          await tempAuthResult.user.delete();

          // Sign in anonymously to keep track of usage
          await _auth.signInAnonymously();
        } on PlatformException catch (error) {
          // TODO
          print('Cannot sign in with email link');
          print(error.code);
          if (error.code == "ERROR_INVALID_ACTION_CODE") {
            _errorMessage = "The link is expired or it's an invalid link";
            notifyListeners();
          }
          print(error.message);
        } catch (error) {
          print('Unhandled error');
          print(error);
        }
      }
    }
  }

  void _initDynamicLinks() async {
    print('initDynamicLinks...');
    final PendingDynamicLinkData dynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLinks(dynamicLink);

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: _handleDynamicLinks,
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  // METHODS //

  // UI will call this method when it shows the error
  void removeError() {
    _errorMessage = null;
  }

  Future<void> fetchStates() async {
    print('fetching auth state...');
    SharedPreferences prefs = await _prefs.future;
    await prefs.reload();

    _hasData = true;
    notifyListeners();
  }

  Stream<FirebaseUser> authStream() => _auth.onAuthStateChanged;

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await _prefs.future;
      print('signing out...');

      final future1 = _auth.signOut();
      final future2 = prefs.setBool(PrefsKey.IS_DRIVER.toString(), false);
      final future3 = prefs.setBool(PrefsKey.IS_TESTER.toString(), false);
      final future4 = prefs.setBool(PrefsKey.IS_SIGN_IN.toString(), false);
      await Future.wait([future1, future2, future3, future4]);
    } catch (error) {
      print('An error occur when signing out');
    }
  }

  Future<bool> isSignedIn() async => await _auth.currentUser() != null;

  Future<bool> isSignedInAsDriver() async {
    SharedPreferences prefs = await _prefs.future;
    RemoteConfig configs = await _remoteConfigs.future;

    try {
      final isDriver = prefs.getBool(PrefsKey.IS_DRIVER.toString()) ?? false;
      final user = await _auth.currentUser();
      final isSignedIn = user != null;

      if (!isSignedIn)
        return false;
      else {
        final configValue =
            configs.getValue(describeEnum(ConfigParams.DriverConfig));

        final DriverConfig driverConfig =
            DriverConfig.fromRemoteConfig(configValue);

        if (!driverConfig.emails.contains(user.email)) {
          //
          print(
              "Cannot login with this email anymore. This driver email might be removed from Firebase Remote Config");

          await logout();

          return false;
        }
      }

      return isDriver && isSignedIn;
    } catch (error) {
      print('error at isSignedInAsDriver');
      print(error);
      return false;
    }
  }

  /// If return false: send email to sign in with email link failed
  Future<bool> sendSignInWithEmailLink(String email) async {
    SharedPreferences prefs = await _prefs.future;

    try {
      await _auth.sendSignInWithEmailLink(
        email: email,
        url: _signInWithEmailLinkUrl,
        androidInstallIfNotAvailable: true,
        handleCodeInApp: true,
        androidMinimumVersion: "16",
        androidPackageName: "com.codinghub.shuttler.mobile",
        iOSBundleID: "com.codinghub.shuttler.mobile",
      );

      print('sign in link sent to $email');

      await prefs.setString(PrefsKey.EMAIL.toString(), email);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<AuthResult> signInWithEmailLink(String email, String link) async {
    return await _auth.signInWithEmailAndLink(email: email, link: link);
  }

  Future<AuthResult> signInWithEmailPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on PlatformException catch (error) {
      // TODO
      print('Cannot signInWithEmailPassword');
      print(error.code);
      print(error.message);
      _errorMessage = error.message;
      notifyListeners();
    } catch (error) {
      print('Unhandled error');
      print(error);
    }

    return null;
  }

  Future<AuthResult> signInAsDriver(String email, String password) async {
    SharedPreferences prefs = await _prefs.future;
    RemoteConfig configs = await _remoteConfigs.future;

    final configValue =
        configs.getValue(describeEnum(ConfigParams.DriverConfig));

    final DriverConfig driverConfig =
        DriverConfig.fromRemoteConfig(configValue);

    // This email is not allowed to sign in as a driver
    if (!driverConfig.emails.contains(email)) {
      print('This email is not allowed to sign in as a driver');
      _errorMessage = "This email is not allowed to sign in as a driver";
      notifyListeners();
      return null;
    }

    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _isDriver = true;

    await prefs.setBool(PrefsKey.IS_DRIVER.toString(), true);

    notifyListeners();

    return result;
  }
}
