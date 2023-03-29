import 'package:flutter/material.dart';
//import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import '../providers/picture_data_provider.dart';

class PhotoItem extends StatelessWidget {
  static const routeName = '/pictureItemScreen';
  @override
  Widget build(BuildContext context) {
    final loadedPhotoItems = Provider.of<PictureDataProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Center(),
    );
  }
}
