import 'package:cloud_firestore/cloud_firestore.dart';

/// Serialization of document in notifications collection in firestore
class Notification {
  String id;
  DateTime date;
  String description;
  String title;
  bool seen;

  Notification.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    this.description = snapshot.data['description'].trim();
    this.title = snapshot.data['title'].trim();
    this.date = DateTime.fromMillisecondsSinceEpoch(
        snapshot?.data['dateFlutter'] ?? DateTime.now().millisecondsSinceEpoch);
    this.seen = false;
  }

  // METHODS //

  toJson() {
    return {
      'date': Timestamp.fromDate(this.date),
      'description': this.description,
      'title': this.title,
    };
  }
}
