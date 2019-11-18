import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttler/models/driver.dart';
import 'package:shuttler/models/notification.dart';

class OnlineDB {
  // SINGLETON //
  static final OnlineDB _singleton = OnlineDB._internal();

  OnlineDB._internal();

  factory OnlineDB() => _singleton;

  static OnlineDB get instance => _singleton;

  // METHODS //

  Stream<List<Driver>> driversStream() {
    return Firestore.instance.collection('drivers').snapshots().map(
        (querySnapshot) => querySnapshot.documents
            .map((document) => Driver.fromDocumentSnapshot(document))
            .toList());
  }

  Stream<Driver> driverStream(String driverId) {
    return Firestore.instance
        .collection('drivers')
        .document(driverId)
        .snapshots()
        .map((document) {
      if (!document.exists) return null;

      return Driver.fromDocumentSnapshot(document);
    });
  }

  Stream<List<Notification>> notificationsStream() {
    return Firestore.instance.collection('notifications').snapshots().map(
        (querySnapshot) => querySnapshot.documents
            .map((document) => Notification.fromDocumentSnapshot(document))
            .toList()
              // Sort newest to oldest
              ..sort((a, b) => b.date.compareTo(a.date)));
  }

  Future<Driver> getDriver(String driverId) async {
    return await Firestore.instance
        .collection('drivers')
        .document(driverId)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) return null;

      return Driver.fromDocumentSnapshot(snapshot);
    });
  }

  Future<void> updateDriver(Driver driver) async {
    await Firestore.instance.collection("drivers").document(driver.id).setData({
      'lastUpdate': Timestamp.now(),
      'location': driver.location,
      'active': driver.active,
    });
  }
}
