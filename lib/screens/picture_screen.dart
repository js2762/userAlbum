import 'package:flutter/material.dart';
//import 'package:full_screen_image/full_screen_image.dart';
//import 'package:useralbum/models/picture_data.dart';
import 'package:provider/provider.dart';
import 'package:useralbum/screens/photo_item_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/picture_data_provider.dart';
//import 'photo_item_screen.dart';

class PictureScreen extends StatefulWidget {
  const PictureScreen({super.key});
  static const routeName = '/picturePageScreen';

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final albumId = ModalRoute.of(context)!.settings.arguments;
      Provider.of<PictureDataProvider>(context)
          .fetchAndSetUserData(albumId as int)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  //List<String> photoUrl = [];
  @override
  Widget build(BuildContext context) {
    //final albumId = ModalRoute.of(context)!.settings.arguments;
    final loadedPhotos = Provider.of<PictureDataProvider>(context).items;

    /* void urlList() {
      loadedPhotos.map(
        (e) {
          urL.add(e.url.toString());
        },
      ).toList();
      //print(urL);
    } */

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pictures',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AnimationLimiter(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1),
                itemCount: loadedPhotos.length,
                itemBuilder: (context, index) =>
                    AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: Duration(milliseconds: 250),
                  columnCount: 10,
                  child: FlipAnimation(
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        //padding: EdgeInsets.all(8),
                        height: 180,
                        width: 180,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(PhotoItem.routeName,
                                arguments: index);
                          },
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/ph.jpeg'),
                            image: NetworkImage(
                                loadedPhotos[index].thumbnailUrl as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
