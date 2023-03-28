import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
//import 'package:useralbum/models/picture_data.dart';
import '../providers/picture_data_provider.dart';
import '../widgets/photo_item.dart';

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
          title: Text('Photos'),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1),
                itemCount: loadedPhotos.length,
                itemBuilder: (context, index) => FullScreenWidget(
                    child: PhotoItem(loadedPhotos[index].url as String,
                        loadedPhotos[index].thumbnailUrl as String),
                    disposeLevel: DisposeLevel.High),
              ));
  }
}
