import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).googleSignOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        child: Center(
          child: Consumer<Auth>(
            builder: (context, Auth, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Auth.gUser?.displayName.toString() != null
                      ? Auth.gUser!.displayName.toString()
                      : 'Login done by id-password'),
                  Text(Auth.gUser?.email != null
                      ? Auth.gUser!.email
                      : 'No data'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
