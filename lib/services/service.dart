import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/user_data.dart';

class ApiServices extends GetConnect {
  String commonUrl = 'https://jsonplaceholder.typicode.com';
  final dio = Dio();

  Future<List<UserData>> userFetchAndSet() async {
    final retrofitService = RetrofitService(dio);
    try {
      final responseData = await retrofitService.getUsers();
      return responseData;
    } catch (e) {
      throw e;
    }
  }
  //
  //

  /* Future<List<dynamic>> userFetchAndSet() async {
    final url = '$commonUrl/users';
    try {
      final response = await dio.get(url);
      final responseData = response.data;
      return responseData;
      //print(responseData);
    } catch (e) {
      throw e;
    }
  } */

//
//
//
  Future<List<dynamic>> albumFetchAndSet() async {
    final url = '$commonUrl/albums';
    try {
      final response = await get(url);
      final responseData = response.body;
      return responseData;
      //print(responseData);
    } catch (e) {
      throw e;
    }
  }

  //
  //
  //
  Future<List<dynamic>> pictureFetchAndSet() async {
    final url = Uri.parse('$commonUrl/photos');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      return responseData;
      //print(responseData);
    } catch (e) {
      throw e;
    }
  }
}
