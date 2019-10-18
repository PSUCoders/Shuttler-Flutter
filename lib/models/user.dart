import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, dynamic> defaultNotifications = {
  "tokens": Map<String, bool>(),
  "notifyLocation": Locations.Campus.toString(),
};

enum Locations { Walmart, Target, Market32, Jade, Campus }

class User {
  String uid;
  String email;
  String password;
  String username;
  Map notifications;

  User();
  User.fromFirebase(FirebaseUser firebaseUser) {
    uid = firebaseUser.uid;
    email = firebaseUser.email;
    username = firebaseUser.email.substring(0, 8);
    notifications = defaultNotifications;
  }
  User.fromSnapshot(DataSnapshot snapshot) {
    uid = snapshot.key;
    email = snapshot.value["email"];
    password = snapshot.value["password"];
    username = snapshot.value["username"];
    notifications = snapshot.value["notifications"];
  }

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "password": password,
      "username": username,
      "notifications": notifications,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return '''User uid: ${this.uid} - email: ${this.email}''';
  }
}
