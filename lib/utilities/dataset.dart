import 'package:shuttler_ios/models/user.dart';

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
  static Data<User> currentUser = Data<User>();
}

void main() {
  // Dataset.
}

