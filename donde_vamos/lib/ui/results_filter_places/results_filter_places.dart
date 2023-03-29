// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/place/detail_place.dart';
import 'package:donde_vamos/ui/results_filter_places/card_event_place.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsFilterPlaces extends StatefulWidget {
  bool allEvents;
  String selectedTypePlace;
  String namePlace;
  String gastronomicPlace;
  ResultsFilterPlaces(
      {required this.namePlace,
      required this.gastronomicPlace,
      required this.allEvents,
      required this.selectedTypePlace});
  @override
  State<ResultsFilterPlaces> createState() => _ResultsFilterPlacesState();
}

class _ResultsFilterPlacesState extends State<ResultsFilterPlaces> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Busqueda de lugares',
            style: GoogleFonts.mavenPro(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: FadeInLeft(
        duration: Duration(milliseconds: 600),
        child: FutureBuilder<List<Place>>(
            future: PlacesProvider().getPlacesFilter(widget.selectedTypePlace,
                widget.allEvents, widget.gastronomicPlace, widget.namePlace),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isEmpty) {
                  return Center(child: Text('Sin resultados'));
                }

                return ListView.builder(
                    padding: EdgeInsets.fromLTRB(5, 10, 10, 0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String direction =
                          snapshot.data![index].lugar_calle.toString() +
                              "," +
                              " " +
                              snapshot.data![index].lugar_numero.toString();
                      direction = direction.replaceAll('Avenida', 'Av.');
                      direction = direction.replaceAll('General', 'Gral.');
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPlace(
                                      idLugar:
                                          snapshot.data![index].lugar_id!)));
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            color: Colors.red,
                            child: FutureBuilder<String>(
                                future: FirebaseStorage().getURLPrincipalPlace(
                                    snapshot.data![index].lugar_nombre
                                        .toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Image.network(snapshot.data!,
                                        fit: BoxFit.cover);
                                  }
                                  return const CircularProgressIndicator();
                                }),
                            height: 100,
                            width: 70,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.room,
                                color: Colors.grey.withOpacity(0.5),
                                size: 14.0),
                            Text(direction, style: AppColors().styleBody),
                          ],
                        ),
                        title: Text(
                            snapshot.data![index].lugar_nombre.toString(),
                            style: GoogleFonts.mavenPro(
                                fontWeight: FontWeight.w500)),
                      );
                      // return CardPlace(snapshot.data![index]);
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
