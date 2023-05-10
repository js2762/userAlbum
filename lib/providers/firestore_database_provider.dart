import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_firestore.dart';

class UserDatabase with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  List<UserCloud> Userdata = [];

  createUser(UserCloud user) async {
    await _db
        .collection('Users')
        .doc(user.id)
        .set(user.toJson())
        .whenComplete(() {
      print('completed');
    }).catchError((error) {
      print(error);
    });
  }

  Future<List<UserCloud>> getUserDetails() async {
    final snapshot = await _db.collection('Users').get();
    Userdata = snapshot.docs.map((e) {
      return UserCloud.fromFirestore(e);
    }).toList();
    print(Userdata);

    return Userdata;
  }

  updateUser(UserCloud user) async {
    await _db.collection('Users').doc(user.id).update(user.toJson());
  }

  deleteUser(String id) async {
    await _db.collection('Users').doc(id).delete();
  }
}
