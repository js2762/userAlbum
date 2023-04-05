import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_background/animated_background.dart';
import '../providers/album_data_provider.dart';
import '../widgets/album_item.dart';

class AlbumPageScreen extends StatefulWidget {
  const AlbumPageScreen({super.key});
  static const routeName = '/albumPageScreen';

  @override
  State<AlbumPageScreen> createState() => _AlbumPageScreenState();
}

class _AlbumPageScreenState extends State<AlbumPageScreen>
    with TickerProviderStateMixin {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      _isLoading = true;

      final uId = ModalRoute.of(context)!.settings.arguments;
      Provider.of<AlbumDataProvider>(context)
          .addAlbumData(uId as int)
          .then((_) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final uId = ModalRoute.of(context)!.settings.arguments;
    final albums = Provider.of<AlbumDataProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Album Page',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : AnimatedBackground(
              behaviour: BubblesBehaviour(),
              vsync: this,
              child: AnimationLimiter(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 8 / 3,
                    //crossAxisSpacing: 10,
                    //mainAxisSpacing: 10,
                  ),
                  itemCount: albums.length,
                  itemBuilder: (context, index) =>
                      AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 200),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: AlbumItem(albums[index].id as int,
                          albums[index].title as String),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
