import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Serialization of document in drivers collection in firestore
class Driver {
  String id;
  GeoPoint location;
  bool active;
  DateTime lastUpdate;
  double direction;

  Driver({this.id, this.location, this.active, this.lastUpdate});

  Driver.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.location = snapshot.data['location'];
    this.active = snapshot.data['active'];
    Timestamp lastUpdate = snapshot.data['lastUpdate'];
    this.lastUpdate = lastUpdate?.toDate();
  }

  // GETTERS //

  LatLng get latLng => LatLng(this.location.latitude, this.location.longitude);

  double get latitude => this.location?.latitude;

  double get longitude => this.location?.longitude;

  // METHODS //

  bool operator ==(other) {
    if (other is Driver && this.active != other.active ||
        this.location != other.location) return false;

    return true;
  }

  int get hashCode => this.id.hashCode;

  Driver copyWith({
    String id,
    bool active,
    DateTime lastUpdate,
    GeoPoint location,
  }) {
    return Driver(
      active: active ?? this.active,
      id: id ?? this.id,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': this.location,
      'active': this.active,
      'lastUpdate': Timestamp.fromDate(this.lastUpdate),
    };
  }
}
