import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/models/notification.dart';

class OnlineDB {
  // SINGLETON //
  FirebaseApp _firebaseApp;

  static final OnlineDB _singleton = OnlineDB._internal();

  OnlineDB._internal() {
    _firebaseApp = FirebaseApp(name: FirebaseApp.defaultAppName);
  }

  OnlineDB({String appName}) {
    if (appName == null) {
      _firebaseApp = FirebaseApp(name: FirebaseApp.defaultAppName);
    } else {
      _firebaseApp = FirebaseApp(name: appName) ??
          FirebaseApp(name: FirebaseApp.defaultAppName);
    }

    print('firebaseApp ${_firebaseApp.name}');
  }

  static OnlineDB get instance => _singleton;

  // METHODS //

  Stream<List<Driver>> driversStream() {
    return Firestore(app: _firebaseApp).collection('drivers').snapshots().map(
        (querySnapshot) => querySnapshot.documents
            .map((document) => Driver.fromDocumentSnapshot(document))
            .toList()
              ..sort((a, b) => a.id.compareTo(b.id)));
  }

  Stream<Driver> driverStream(String driverId) {
    return Firestore(app: _firebaseApp)
        .collection('drivers')
        .document(driverId)
        .snapshots()
        .map((document) {
      if (!document.exists) return null;

      return Driver.fromDocumentSnapshot(document);
    });
  }

  Stream<List<Notification>> notificationsStream() {
    print('noti called');
    return Firestore(app: _firebaseApp)
        .collection('notifications')
        .snapshots()
        .map((querySnapshot) => querySnapshot.documents
            .map((document) => Notification.fromDocumentSnapshot(document))
            .toList()
              // Sort newest to oldest
              ..sort((a, b) => b.date.compareTo(a.date)));
  }

  Future<Driver> getDriver(String driverId) async {
    return await Firestore(app: _firebaseApp)
        .collection('drivers')
        .document(driverId)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) return null;

      return Driver.fromDocumentSnapshot(snapshot);
    });
  }

  Future<void> updateDriver(Driver driver) async {
    await Firestore(app: _firebaseApp)
        .collection("drivers")
        .document(driver.id)
        .setData(driver.copyWith(lastUpdate: DateTime.now()).toJson());
  }

  // Log error to firestore
  Future<DocumentReference> writeDriverLog(
    String driverId,
    PlatformException error,
  ) async {
    return await Firestore(app: _firebaseApp)
        .collection("drivers")
        .document(driverId)
        .collection('error_logs')
        .add({
      'code': error.code,
      'message': error.message,
      'details': error.details,
      'time': Timestamp.now(),
    });
  }
}
