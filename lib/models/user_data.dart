//import 'package:flutter/material.dart';

class UserData {
  int? id;
  final String? name;
  final String? username;
  final String? email;
  Map<String, String>? address;
  final String? phone;
  Map<String, String>? website;

  UserData({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
  });
}
