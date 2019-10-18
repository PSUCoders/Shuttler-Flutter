import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Serialization of document in drivers collection in firestore
class Driver {
  String id;
  GeoPoint location;
  bool active;

  Driver.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.location = snapshot.data['location'];
    this.active = snapshot.data['active'];
  }

  // GETTERS //

  LatLng get latLng => LatLng(this.location.latitude, this.location.longitude);

  // METHODS //

  toJson() {
    return {
      'location': GeoPoint(
        this.location?.latitude,
        this.location?.longitude,
      ),
      'active': this.active,
    };
  }
}
