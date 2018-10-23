import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Map<String, dynamic> defaultNotifications = {
  "enabled" : true,
  "notifyLocation" : "Campus",
  "timeAhead" : 5
};

class User {
  String key;
  String email;
  String password;
  String username;
  Map notifications;

  User();
  User.fromFirebase(FirebaseUser firebaseUser) 
    : key = firebaseUser.uid,
      email = firebaseUser.email,
      username = firebaseUser.email.substring(0, 8),
      notifications = defaultNotifications;
  User.fromSnapshot(DataSnapshot snapshot) 
    : key = snapshot.key,
      email = snapshot.value["email"],
      password = snapshot.value["password"],
      username = snapshot.value["username"],
      notifications = snapshot.value["notifications"];

  toJson() {
    return {
      "email": email,
      "password": password,
      "username": username,
      "notifications": notifications,
    };
  }
}