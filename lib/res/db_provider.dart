import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_chat/model/message.dart';
import 'package:flutter_fire_chat/model/user.dart';
import 'dart:async';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<List<User>> streamUsers() {
    var ref = _db.collection('users');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  Stream<List<Message>> streamMessages(String chatId) {
    var ref = _db.collection('messages')
      .document(chatId)
      .collection(chatId)
      .orderBy("timestamp",descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> createMessage(String chatId, Message message) {
    return _db.collection("messages")
      .document(chatId)
      .collection(chatId)
      .add(message.toMap());
  }

  


  Future<void> createUser(FirebaseUser user) {
    return _db
        .collection('users')
        .document(user.uid)
        .setData({
          "name": user.displayName,
          "email":user.email,
          "avatar":user.photoUrl
        },merge: true);
  }

  Future<void> updateUserProfile(User user) {
    return _db
      .collection('users')
      .document(user.id)
      .setData(user.toMap());
  }
}
