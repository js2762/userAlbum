import 'package:cloud_firestore/cloud_firestore.dart';

class UserCloud {
  final String? id;
  final String? name;
  final String? number;

  UserCloud({
    this.id,
    this.name,
    this.number,
  });

  toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
    };
  }

  factory UserCloud.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserCloud(
      // id: document.id,  // if you used auto generated documnet-id
      id: data['id'], // manually set the document-id which is same as user-id
      name: data['name'],
      number: data['number'],
    );
  }
}
