import 'package:flutter/material.dart';
//import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/picture_data_provider.dart';

class PhotoItem extends StatefulWidget {
  static const routeName = '/pictureItemScreen';

  const PhotoItem({super.key});

  @override
  State<PhotoItem> createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  final carouselCntlr = CarouselController();
  @override
  Widget build(BuildContext context) {
    final photoIndex = ModalRoute.of(context)!.settings.arguments;
    final loadedPhotoItems = Provider.of<PictureDataProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 600,
                width: 600,
                child: CarouselSlider.builder(
                    itemCount: loadedPhotoItems.length,
                    itemBuilder: (context, index, realIndex) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            loadedPhotoItems[index].url as String,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            left: 0,
                            child: IconButton(
                                onPressed: () {
                                  carouselCntlr.previousPage();
                                },
                                icon: const Icon(
                                  Icons.navigate_before,
                                  color: Colors.white,
                                  size: 50,
                                )),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  carouselCntlr.nextPage();
                                },
                                icon: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                  size: 50,
                                )),
                          ),
                        ],
                      );
                    },
                    carouselController: carouselCntlr,
                    options: CarouselOptions(
                      height: double.infinity,
                      //height: 400,
                      initialPage: photoIndex as int,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1, // to display full item
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
