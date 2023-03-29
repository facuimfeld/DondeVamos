// ignore_for_file: sort_child_properties_last

import 'package:carousel_slider/carousel_slider.dart';
import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPlace extends StatefulWidget {
  Place place;
  CardPlace(this.place);

  @override
  State<CardPlace> createState() => _CardPlaceState();
}

class _CardPlaceState extends State<CardPlace> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 1,
      child: Card(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                    child: FutureBuilder<List<String>>(
                        future: FirebaseStorage().getURLPlace(
                            widget.place.lugar_nombre.toString().trim()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            List<String> urls = snapshot.data!;
                            return CarouselSlider.builder(
                                itemCount: urls.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Container(
                                      child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(urls[pageViewIndex],
                                                fit: BoxFit.cover),
                                            Positioned(
                                                left: 3.0,
                                                top: 2.0,
                                                child: IconButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(Icons.arrow_back,
                                                        color: Colors.white,
                                                        size: 28.0))),
                                          ]),
                                    ),
                                options: CarouselOptions());
                          }
                          return const CircularProgressIndicator();
                        }),
                  ),
                  flex: 3),
              Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Text(
                                      widget.place.lugar_nombre.toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.mavenPro(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.5,
                                      ),
                                    )),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.room,
                                      size: 15.0,
                                      color: Colors.grey.withOpacity(0.65),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(widget.place.lugar_calle.toString() +
                                        ' ' +
                                        widget.place.lugar_numero.toString())
                                  ],
                                )),
                          ],
                        )),
                  ),
                  flex: 2),
            ],
          )),
    );
  }
}
