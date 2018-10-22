import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String email;
  String password;
  String username;
  Map notifications;

  User();
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