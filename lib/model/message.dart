import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String userId;
  final String description;
  final DateTime timestamp;

  Message({this.id,this.userId, this.description, this.timestamp});

  factory Message.fromMap(Map data) {
    return Message(
      userId: data['user_id'],
      description: data['description'],
      timestamp: data['timestamp'],
    );
  }

  factory Message.fromFirestore(DocumentSnapshot doc) {
    return Message(
      id: doc.documentID,
      userId: doc.data['user_id'],
      description: doc.data['description'],
      timestamp: doc.data['timestamp']?.toDate(),
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "user_id":userId,
      "description": description,
      "timestamp":FieldValue.serverTimestamp(),
      "id":id,
    };
  }
}