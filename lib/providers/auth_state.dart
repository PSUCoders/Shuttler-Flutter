import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuttler/utilities/contants.dart';

/// CONSTANTS
final String _signInWithEmailLinkUrl = "https://shuttler.page.link/verifyEmail";

/// Store all settings to device memory
class AuthState extends ChangeNotifier {
  bool _hasData;
  bool _isSignIn;
  bool _emailSent;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Completer<SharedPreferences> _prefs = Completer();

  AuthState() {
    // Get SharedPreferences instance
    SharedPreferences.getInstance().then((prefs) => _prefs.complete(prefs));
    fetchStates();
    _initDynamicLinks();
  }

  // GETTERS //

  bool get hasData => _hasData ?? false;

  bool get isSignIn => _isSignIn ?? false;

  bool get emailSent => _emailSent ?? false;

  // METHODS //

  fetchStates() async {
    print('fetching auth state...');
    SharedPreferences prefs = await _prefs.future;
    await prefs.reload();

    final isSignIn = prefs.getBool(PrefsKey.IS_SIGN_IN.toString());
    _isSignIn = isSignIn ?? false;

    _hasData = true;
    notifyListeners();
  }

  authStream() => _auth.onAuthStateChanged;

  logout() async {
    print('signing out...');
    await _auth.signOut();
  }

  Future<dynamic> _handleDynamicLinks(
      PendingDynamicLinkData dynamicLink) async {
    SharedPreferences prefs = await _prefs.future;

    final Uri deepLink = dynamicLink?.link;
    print('deepLink: $deepLink');

    if (deepLink != null) {
      final isSignInWithEmailLink =
          await _auth.isSignInWithEmailLink(deepLink.toString());

      if (isSignInWithEmailLink) {
        try {
          // check user email match local storage
          final email = prefs.getString(PrefsKey.EMAIL.toString());

          if (email == null) {
            // TODO handle
            return;
          }

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
          print(error.message);
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

      await prefs.setString(PrefsKey.EMAIL.toString(), email);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<AuthResult> signInWithEmailLink(String email, String link) async {
    return _auth.signInWithEmailAndLink(email: email, link: link);
  }
}
