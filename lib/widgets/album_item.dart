import 'package:flutter/material.dart';
import 'package:useralbum/screens/picture_screen.dart';

class AlbumItem extends StatelessWidget {
  int id;
  String title;
  AlbumItem(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black26),
          margin: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(PictureScreen.routeName, arguments: id);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/photo2.png'),
              ),
              title: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
