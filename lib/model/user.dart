import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String avatar;

  User({this.id,this.email, this.name, this.avatar});

  factory User.fromMap(Map data) {
    return User(
      email: data['email'],
      name: data['name'],
      avatar: data["avatar"]
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      email: doc.data['email'],
      name: doc.data['name'],
      avatar: doc.data["avatar"]
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "email":email,
      "name": name,
      "avatar":avatar,
      "id":id,
    };
  }
}