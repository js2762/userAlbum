import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import '../providers/user_data_provider.dart';
import '../screens/album_page_screen.dart';

class UserItem extends StatelessWidget {
  int id;
  String name;
  String email;
  UserItem(this.id, this.name, this.email);

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of(context, listen: false);
    return Container(
      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: GridTile(
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AlbumPageScreen.routeName, arguments: id);
            },
            child: Image.asset(
              'assets/images/photo.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/photo3.jpeg'),
            ),
            title: Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(email),
          ),
        ),
      ),
    );
  }
}
