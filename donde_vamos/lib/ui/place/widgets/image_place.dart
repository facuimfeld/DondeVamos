// ignore_for_file: sort_child_properties_last

import 'package:carousel_slider/carousel_slider.dart';
import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImagePlace extends StatelessWidget {
  String namePlace;
  ImagePlace(this.namePlace);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: FutureBuilder<List<String>>(
                future: FirebaseStorage().getURLPlace(namePlace),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    /*
                    return Stack(fit: StackFit.expand, children: [
                      Image.network(snapshot.data!, fit: BoxFit.cover),
                      Positioned(
                          left: 3.0,
                          top: 2.0,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,
                                  color: Colors.white, size: 28.0))),
                    ]);*/
                    if (snapshot.connectionState == ConnectionState.done) {
                      List<String> urls = snapshot.data!;
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: CarouselSlider.builder(
                            itemCount: urls.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                    int pageViewIndex) =>
                                Image.network(urls[itemIndex],
                                    fit: BoxFit.cover),
                            options: CarouselOptions(
                              autoPlay: true,
                            )),
                      );
                    }
                  }
                  return const CircularProgressIndicator();
                }),
            color: Colors.black,
            width: MediaQuery.of(context).size.width),
        flex: 1);
  }
}
