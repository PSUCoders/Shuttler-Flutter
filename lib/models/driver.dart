import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  String key;
  String g;
  double latitude;
  double longtitude;

  Driver();
  Driver.fromSnapshot(DataSnapshot snapshot) 
    : key = snapshot.key,
      g = snapshot.value["g"],
      latitude = snapshot.value["l"][0],
      longtitude = snapshot.value["l"][1];

  toJson() {
    return {
      "g": g,
      "l": {
        0: latitude,
        1: longtitude,
      },
    };
  }

  getLatLng() {
    return LatLng(latitude,longtitude);
  }
}