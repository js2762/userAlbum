import 'package:get/get.dart';
import '../models/user_data.dart';
import '../services/service.dart';

class UserDataGetX extends GetxController {
  List<UserData> _items = [];

  List<UserData> get items {
    return [..._items];
  }

  Future<void> addUserData() async {
    var ob = ApiServices();
    Future<List<UserData>> responseData2 = ob.userFetchAndSet();
    List<UserData> responseData3 = await responseData2;
    _items = responseData3;
    //print(_items);
    update();
  }
}
