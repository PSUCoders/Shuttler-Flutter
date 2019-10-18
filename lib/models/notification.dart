import 'package:cloud_firestore/cloud_firestore.dart';

/// Serialization of document in notifications collection in firestore
class Notification {
  String id;
  DateTime date;
  String description;
  String title;

  Notification.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.documentID;
    // TODO
    // this.date =
    // snapshot.data['date']?.toDate(); // Convert Timestamp to DateTime
    this.description = snapshot.data['description'];
    this.title = snapshot.data['title'];
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
