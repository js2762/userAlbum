import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
//import 'package:full_screen_image/full_screen_image.dart';

class PhotoItem extends StatelessWidget {
  String url;
  String thumbnailUrl;
  PhotoItem(this.url, this.thumbnailUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
      width: 100,
      child: FadeInImage(
        placeholder: AssetImage('assets/images/ph.jpeg'),
        image: NetworkImage(thumbnailUrl),
      ),
    );
  }
}
