import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuttler_flutter/models/driver.dart';
import 'package:shuttler_flutter/models/notification.dart';

class DBService {
  Stream<List<Driver>> get driversStream {
    return Firestore.instance
        .collection('drivers')
        .getDocuments()
        .asStream()
        .map((querySnapshot) => querySnapshot.documents
            .map((document) => Driver.fromDocumentSnapshot(document))
            .toList());
  }

  Stream<List<Notification>> get notificationsStream {
    return Firestore.instance
        .collection('notifications')
        .getDocuments()
        .asStream()
        .map((querySnapshot) => querySnapshot.documents
            .map((document) => Notification.fromDocumentSnapshot(document))
            .toList());
  }
}
