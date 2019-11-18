import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Serialization of document in drivers collection in firestore
class Driver {
  String id;
  GeoPoint location;
  bool active;
  DateTime lastUpdate;

  Driver({this.id, this.location, this.active, this.lastUpdate});

  Driver.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.location = snapshot.data['location'];
    this.active = snapshot.data['active'];
    Timestamp lastUpdate = snapshot.data['lastUpdate'];
    this.lastUpdate = lastUpdate.toDate();
  }

  // GETTERS //

  LatLng get latLng => LatLng(this.location.latitude, this.location.longitude);

  // METHODS //

  bool operator ==(other) {
    if (other is Driver && this.active != other.active ||
        this.location != other.location) return false;

    return true;
  }

  int get hashCode => this.id.hashCode;

  toJson() {
    return {
      'location': this.location,
      'active': this.active,
      'lastUpdate': Timestamp.fromDate(this.lastUpdate),
    };
  }
}
