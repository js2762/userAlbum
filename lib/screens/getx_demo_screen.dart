import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useralbum/models/user_data.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../getX/user_getx.dart';
import '../providers/user_data_provider.dart';
import '../widgets/user_item.dart';
import '../widgets/app_drawer.dart';
//import '../models/user_data.dart';

class GetXScreen extends StatefulWidget {
  const GetXScreen({super.key});
  static const routeName = '/getXScreen';

  @override
  State<GetXScreen> createState() => _GetXScreenState();
}

class _GetXScreenState extends State<GetXScreen> with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;
  //List<UserData> searchedData = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      _isLoading = true;

      Get.put(UserDataGetX()).addUserData().then((_) {
        _isLoading = false;
      });
    }
    //searchedData = Provider.of<UserDataProvider>(context).items;
    _isInit = false;

    super.didChangeDependencies();
  }

  //final _textFocusNode = FocusNode();
  /* void searchUser(String value, List<UserData> users) {
    searchedData.clear();
    if (value.isEmpty) {
      setState(() {
        //searchedData = users;
      });
      //print(searchedData);
      return;
    } else {
      //print(searchedData);
      setState(() {
        users.forEach((element) {
          if (element.name!.toLowerCase().contains(
              value.toLowerCase().trim().replaceAll(RegExp(r'\b\s+\b'), ''))) {
            searchedData.add(element);
          }
        });
      });
    }
  } */

  final textEdctrl = TextEditingController();
  //final userController = Get.put(UserDataGetX());
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar;
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    //List<UserData> users = Get.put(UserDataGetX()).items;   NOTE: not woked
    // List<UserData> searchedData = Provider.of<UserDataProvider>(context).searchItems;

    //searchedData = users;
    //var value;
    appBar = AppBar(
      title: const Text(
        'User Page',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
      ),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: (deviceSize.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.9,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: AnimationLimiter(
                child: GetBuilder(
                  init: UserDataGetX(),
                  builder: (controller) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(13),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      itemCount: controller.items.length,
                      itemBuilder: (context, index) =>
                          AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        columnCount: 2,
                        child: FlipAnimation(
                          child: UserItem(
                              controller.items[index].id as int,
                              controller.items[index].name as String,
                              controller.items[index].email as String),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
