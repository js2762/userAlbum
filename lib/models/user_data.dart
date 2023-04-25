//import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_data.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class RetrofitService {
  factory RetrofitService(Dio dio, {String baseUrl}) = _RetrofitService;

  @GET('/users')
  Future<List<UserData>> getUsers();
}

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

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
