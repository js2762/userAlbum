import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_data.dart';
//import '../models/http_exception.dart';

class UserDataProvider with ChangeNotifier {
  List<UserData> _items = [];

  List<UserData> get items {
    return [..._items];
  }

  /* searchUser(String value) {
    return _items
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
  } */

  Future<void> fetchAndSetUserData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      //print(responseData);
      final List<UserData> loadedUserData = [];
      responseData.forEach((
        uData,
      ) {
        loadedUserData.add(UserData(
          id: uData['id'],
          name: uData['name'],
          email: uData['email'],
        ));
      });

      _items = loadedUserData;
      //print(_items);
      notifyListeners();

      // responseData.map((e) {
      //   loadedUserData.add(
      //     UserData(

      //     )
      //   );
      // });
    } catch (e) {
      throw e;
    }
  }
}
