import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/album_data.dart';
import '../services/service.dart';

class AlbumDataProvider with ChangeNotifier {
  List<AlbumData> _items = [];

  List<AlbumData> get items {
    return [..._items];
  }

  /*AlbumData findById(int id) {
    return _items.firstWhere((element) => element.userId == id);
  } */

  Future<void> addAlbumData(int id) async {
    var ob = ApiServices();
    Future<List<dynamic>> responseData2 = ob.albumFetchAndSet();
    List<dynamic> responseData3 = await responseData2;
    final List<AlbumData> loadedAlbumData = [];
    for (var alData in responseData3) {
      if (id == alData['userId']) {
        loadedAlbumData.add(
          AlbumData(
            userId: alData['userId'],
            id: alData['id'],
            title: alData['title'],
          ),
        );
      }
    }
    _items = loadedAlbumData;
    notifyListeners();
  }

  /* Future<void> fetchAndSetUserData(int id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      //print(responseData);
      final List<AlbumData> loadedAlbumData = [];
      responseData.forEach((alData) {
        if (id == alData['userId']) {
          loadedAlbumData.add(
            AlbumData(
              userId: alData['userId'],
              id: alData['id'],
              title: alData['title'],
            ),
          );
        }
      });

      _items = loadedAlbumData;
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
}
