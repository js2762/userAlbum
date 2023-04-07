import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_data.dart';
import '../services/service.dart';
//import '../models/http_exception.dart';

class UserDataProvider with ChangeNotifier {
  List<UserData> _items = [];

  final List<UserData> _searchedData = [];

  List<UserData> get items {
    return [..._items];
  }

  List<UserData> get searchItems {
    return [..._searchedData];
  }

  Future<void> addUserData() async {
    var ob = ApiServices();
    Future<List<dynamic>> responseData2 = ob.userFetchAndSet();
    List<dynamic> responseData3 = await responseData2;
    final List<UserData> loadedUserData = [];
    for (var uData in responseData3) {
      loadedUserData.add(UserData(
        id: uData['id'],
        name: uData['name'],
        email: uData['email'],
      ));
    }
    _items = loadedUserData;
    notifyListeners();
  }

  void searchUser(String value) {
    _searchedData.clear();
    if (value.isEmpty) {
      //searchedData = users;
      notifyListeners();
      return;
    } else {
      for (var element in items) {
        if (element.name!.toLowerCase().contains(
            value.toLowerCase().trim().replaceAll(RegExp(r'\b\s+\b'), ''))) {
          _searchedData.add(element);
        }
      }
      //print(_searchedData);
      notifyListeners();
    }
  }

  /* Future<void> fetchAndSetUserData() async {
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
  } */

  /* searchUser(String value) {
    return _items
        .where((element) =>
            element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
  } */
}
