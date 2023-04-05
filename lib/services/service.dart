import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../models/user_data.dart';

class ApiServices {
  String commonUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> userFetchAndSet() async {
    final url = Uri.parse('$commonUrl/users');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      return responseData;
      //print(responseData);
    } catch (e) {
      throw e;
    }
  }

//
//
//
  Future<List<dynamic>> albumFetchAndSet() async {
    final url = Uri.parse('$commonUrl/albums');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
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
