import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/album_data.dart';

class AlbumDataProvider with ChangeNotifier {
  List<AlbumData> _items = [];

  List<AlbumData> get items {
    return [..._items];
  }

  /*AlbumData findById(int id) {
    return _items.firstWhere((element) => element.userId == id);
  } */

  Future<void> fetchAndSetUserData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      //print(responseData);
      final List<AlbumData> loadedUserData = [];
      responseData.forEach((alData) {
        if (id == alData['userId']) {
          loadedUserData.add(
            AlbumData(
              userId: alData['userId'],
              id: alData['id'],
              title: alData['title'],
            ),
          );
        }
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
