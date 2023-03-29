// ignore_for_file: prefer_const_constructors

import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/models/suscription_place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/results_filter_places/card_event_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class SuscriptionsPlaces extends StatefulWidget {
  const SuscriptionsPlaces({super.key});

  @override
  State<SuscriptionsPlaces> createState() => _SuscriptionsPlacesState();
}

class _SuscriptionsPlacesState extends State<SuscriptionsPlaces> {
  List<Place> places = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<Place>> getPlacesSuscribed() async {
    List<Place> myPlaces = [];
    List<SuscriptionPlace> suscriptPlace =
        await SuscriptionProvider().getSuscriptionsPlaces();
    for (int i = 0; i <= suscriptPlace.length - 1; i++) {
      Place place = await PlacesProvider().getPlace(suscriptPlace[i].lugar);
      myPlaces.add(place);
    }
    print('my places' + myPlaces.length.toString());
    return myPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
        future: getPlacesSuscribed(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  print('LENGTH' + places.length.toString());
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                            'Todavia no te has suscripto a ningun lugar',
                            style: GoogleFonts.mavenPro()));
                  }
                  String direction =
                      snapshot.data![index].lugar_calle.toString() +
                          " " +
                          snapshot.data![index].lugar_numero.toString();
                  direction = direction.replaceAll('Avenida', 'Av.');
                  direction = direction.replaceAll('General', 'Gral.');
                  return ListTile(
                    leading: FutureBuilder<String>(
                        future: FirebaseStorage().getURLPrincipalPlace(
                            snapshot.data![index].lugar_nombre.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.toString()),
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                    title: Text(snapshot.data![index].lugar_nombre.toString()),
                    subtitle: Row(
                      children: [
                        Icon(Icons.room, color: Colors.grey, size: 16.0),
                        Text(direction,
                            style: GoogleFonts.mavenPro(
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
