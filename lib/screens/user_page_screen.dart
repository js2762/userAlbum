import 'package:flutter/material.dart';
//import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:provider/provider.dart';
import 'package:useralbum/models/user_data.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../getX/user_getx.dart';
import '../providers/user_data_provider.dart';
import '../widgets/user_item.dart';
import '../widgets/app_drawer.dart';
//import '../models/user_data.dart';

class UserPageScreen extends StatefulWidget {
  const UserPageScreen({super.key});
  static const routeName = '/userPageScreen';

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  var _isInit = true;
  var _isLoading = false;
  //List<UserData> searchedData = [];
  final userController = Get.put(UserDataGetX());

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      _isLoading = true;

      /* userController.addUserData().then((_) {
        _isLoading = false;
      }); */

      Provider.of<UserDataProvider>(context).addUserData().then((_) {
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
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar;
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    List<UserData> users = Provider.of<UserDataProvider>(context).items;
    List<UserData> searchedData =
        Provider.of<UserDataProvider>(context).searchItems;
    // final textController = TextEditingController();

    //searchedData = users;
    //var value;
    appBar = AppBar(
      title: const Text(
        'User Page',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
      ),
      centerTitle: true,
    );

    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Scaffold(
          appBar: appBar,
          drawer: const AppDrawer(),
          body: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Consumer<UserDataProvider>(
                    builder: (context, userDataProvider, _) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: TextField(
                          controller: textEdctrl,
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            userDataProvider.searchUser(value);
                          },
                          onSubmitted: (value) {
                            userDataProvider.searchUser(value);
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    textEdctrl.text = '';
                                    userDataProvider
                                        .searchUser(textEdctrl.text);
                                  },
                                  icon: Icon(Icons.cancel))),
                        ),
                      );
                    },
                  ),

                  /*   Consumer<UserDataProvider>(
                    builder: (context, userDataProvider, _) {
                      return SearchBarAnimation(
                          enableKeyboardFocus: true,
                          textInputType: TextInputType.name,
                          onSaved: (value) => userDataProvider
                              .searchUser(value), //searchUser(value, users),
                          onFieldSubmitted: (value) => userDataProvider
                              .searchUser(value), //searchUser(value, users),
                          onChanged: (value) => userDataProvider
                              .searchUser(value), //searchUser(value, users),
                          //onEditingComplete: (value) => searchUser(value, users),
                          enableBoxBorder: true,
                          buttonShadowColour: Colors.deepOrange,
                          durationInMilliSeconds: 350,
                          textEditingController: textEdctrl,
                          isOriginalAnimation: false,
                          trailingWidget: const Icon(Icons.mic),
                          secondaryButtonWidget: const Icon(
                            Icons.cancel,
                            color: Colors.deepOrange,
                          ),
                          buttonWidget: const Icon(
                            Icons.search,
                            color: Colors.deepOrange,
                          ));
                    },
                  ), */
                  //
                  //
                  _isLoading
                      ? Container(
                          height: (deviceSize.height -
                                  appBar.preferredSize.height -
                                  mediaQuery.padding.top) *
                              0.9,
                          child:
                              const Center(child: CircularProgressIndicator()))
                      : Container(
                          height: (deviceSize.height -
                                  appBar.preferredSize.height -
                                  mediaQuery.padding.top) *
                              0.9,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: AnimationLimiter(
                              child: GridView.builder(
                                padding: const EdgeInsets.all(13),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2 / 3,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: searchedData.isEmpty
                                    ? users.length
                                    : searchedData.length,
                                itemBuilder: (context, index) =>
                                    AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  columnCount: 2,
                                  child: searchedData.isEmpty
                                      ? FlipAnimation(
                                          child: UserItem(
                                              users[index].id as int,
                                              users[index].name as String,
                                              users[index].email as String),
                                        )
                                      : UserItem(
                                          searchedData[index].id as int,
                                          searchedData[index].name as String,
                                          searchedData[index].email as String,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Container(
//   width: deviceSize.width,
//   child: SingleChildScrollView(
//     child: Column(
//       children: [
//         SearchBarAnimation(
//             textEditingController: TextEditingController(),
//             isOriginalAnimation: false,
//             trailingWidget: Icon(Icons.mic),
//             secondaryButtonWidget: Icon(Icons.cancel),
//             buttonWidget: Icon(Icons.search)),
//         SizedBox(
//           height: 10,
//         ),
//         GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 3 / 2,
//               crossAxisSpacing: 20,
//               mainAxisSpacing: 20),
//           itemCount: users.length,
//           itemBuilder: (context, index) =>
//               UserItem(users[index].name as String),
//         )
//       ],
//     ),
//   ),
// ),
