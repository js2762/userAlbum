import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firestore_database_provider.dart';
import '../models/user_firestore.dart';

class CloudFirestore extends StatefulWidget {
  const CloudFirestore({super.key});

  @override
  State<CloudFirestore> createState() => _CloudFirestoreState();
}

class _CloudFirestoreState extends State<CloudFirestore> {
  // final user = UserCloud(
  //   id: DateTime.now().toString(),
  //   name: 'jaimin',
  //   number: '1234567890',
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Firestore'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              final user = UserCloud(
                id: '4',
                name: 'dilip',
                number: '187',
              );
              Provider.of<UserDatabase>(context, listen: false).deleteUser('4');
              print('working');
            },
            child: Text('click here to post data on cloudStore')),
      ),
    );
  }
}
