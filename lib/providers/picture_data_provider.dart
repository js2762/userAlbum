import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/picture_data.dart';
//import '../models/http_exception.dart';

class PictureDataProvider with ChangeNotifier {
  List<PictureData> _items = [];

  List<PictureData> get items {
    return [..._items];
  }

  Future<void> fetchAndSetUserData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      //print(responseData);
      final List<PictureData> loadedUserData = [];
      responseData.forEach((pData) {
        if (id == pData['albumId']) {
          loadedUserData.add(PictureData(
            albumId: pData['albumId'],
            id: pData['id'],
            title: pData['title'],
            url: pData['url'],
            thumbnailUrl: pData['thumbnailUrl'],
          ));
        }
      });

      _items = loadedUserData;
      // print(_items);
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
