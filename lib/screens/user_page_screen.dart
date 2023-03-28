import 'package:flutter/material.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:provider/provider.dart';
import 'package:useralbum/models/user_data.dart';
import '../providers/user_data_provider.dart';
import '../widgets/user_item.dart';
import '../widgets/app_drawer.dart';
import '../models/user_data.dart';

class UserPageScreen extends StatefulWidget {
  const UserPageScreen({super.key});
  static const routeName = '/userPageScreen';

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<UserData> searchedData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<UserDataProvider>(context).fetchAndSetUserData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    //searchedData = Provider.of<UserDataProvider>(context).items;
    _isInit = false;

    super.didChangeDependencies();
  }

  //final _textFocusNode = FocusNode();
  void searchUser(String value, List<UserData> users) {
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
          if (element.name!.toLowerCase().contains(value.toLowerCase())) {
            searchedData.add(element);
          }
        });
      });
    }
  }

  final textEdctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget app_Bar;
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    final loadedUserData = Provider.of<UserDataProvider>(context);
    List<UserData> users = loadedUserData.items;

    //searchedData = users;
    //var value;
    app_Bar = AppBar(
      title: Text('User Page'),
      centerTitle: true,
    );

    return Scaffold(
        appBar: app_Bar,
        drawer: AppDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*  Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  //controller: _textEdctrl,
                  //focusNode: _textFocusNode,
                  onChanged: (value) {
                    searchUser(value, users);
                  },
                  onSubmitted: (value) {
                    searchUser(value, users);
                  },
                ),
              ), */

              SearchBarAnimation(
                  textInputType: TextInputType.name,
                  onSaved: (value) => searchUser(value, users),
                  onFieldSubmitted: (value) => searchUser(value, users),
                  onChanged: (value) => searchUser(value, users),
                  //onEditingComplete: (value) => searchUser(value, users),
                  enableBoxBorder: true,
                  buttonShadowColour: Colors.deepOrange,
                  durationInMilliSeconds: 350,
                  textEditingController: textEdctrl,
                  isOriginalAnimation: false,
                  trailingWidget: Icon(Icons.mic),
                  secondaryButtonWidget: Icon(
                    Icons.cancel,
                    color: Colors.deepOrange,
                  ),
                  buttonWidget: Icon(
                    Icons.search,
                    color: Colors.deepOrange,
                  )),
              //
              //
              _isLoading
                  ? Container(
                      height: (deviceSize.height -
                              app_Bar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.9,
                      child: Center(child: CircularProgressIndicator()))
                  : Container(
                      height: (deviceSize.height -
                              app_Bar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.9,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: GridView.builder(
                          padding: EdgeInsets.all(13),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: searchedData.isEmpty
                              ? users.length
                              : searchedData.length,
                          itemBuilder: (context, index) => searchedData.isEmpty
                              ? UserItem(
                                  users[index].id as int,
                                  users[index].name as String,
                                  users[index].email as String)
                              : UserItem(
                                  searchedData[index].id as int,
                                  searchedData[index].name as String,
                                  searchedData[index].email as String),
                        ),
                      ),
                    ),
            ],
          ),
        ));
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