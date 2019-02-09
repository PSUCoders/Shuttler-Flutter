import 'package:shuttler_ios/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class Data<T> {
  T _value;
  DateTime _lastModified;

  T get value => _value;
  DateTime get lastModified => _lastModified;

  set value(T value) {
    _value = value;
    _lastModified = DateTime.now();
  }

}

class Dataset {
  // static List<Event> _allEvents;
  static Data<User> currentUser = Data();
  static Data<String> token = Data<String>();
  static Data<FirebaseApp> firebaseApp = Data();
  static Data<double> statusBarHeight = Data();
  static Data<bool> isDriver = Data();
}

void main() {
  // Dataset.
}

