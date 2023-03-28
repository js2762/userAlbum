import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/album_data_provider.dart';
import '../widgets/album_item.dart';

class AlbumPageScreen extends StatefulWidget {
  const AlbumPageScreen({super.key});
  static const routeName = '/albumPageScreen';

  @override
  State<AlbumPageScreen> createState() => _AlbumPageScreenState();
}

class _AlbumPageScreenState extends State<AlbumPageScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final uId = ModalRoute.of(context)!.settings.arguments;
      Provider.of<AlbumDataProvider>(context)
          .fetchAndSetUserData(uId as int)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final uId = ModalRoute.of(context)!.settings.arguments;
    final loadedAlbumData = Provider.of<AlbumDataProvider>(context);
    final albums = loadedAlbumData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Album Page'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 8 / 3,
                //crossAxisSpacing: 10,
                //mainAxisSpacing: 10,
              ),
              itemCount: albums.length,
              itemBuilder: (context, index) => AlbumItem(
                  albums[index].id as int, albums[index].title as String),
            ),
    );
  }
}
