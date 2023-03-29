// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:donde_vamos/device/gps.dart';
import 'package:donde_vamos/firebase/firebase_storage.dart';
//import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
//import 'package:donde_vamos/resources/dates_provider.dart';
//import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/home/widgets/calendar_date.dart';
import 'package:donde_vamos/ui/home/widgets/calendar_days.dart';
import 'package:donde_vamos/ui/home/widgets/row_place.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class CardNearbyEvent extends StatefulWidget {
  Event event;
  CardNearbyEvent({required this.event});

  @override
  State<CardNearbyEvent> createState() => _CardNearbyEventState();
}

class _CardNearbyEventState extends State<CardNearbyEvent> {
  late double distanceEvent;
  @override
  void initState() {
    super.initState();

    print('evento' + widget.event.evento_nombre);
  }

  Future<void> getDistance() async {}
  Future<double> getDistanceFromEvent() async {
    Place place = await PlacesProvider().getPlace(widget.event.evento_lugar);
    String direction = place.lugar_calle.toString() +
        " " +
        place.lugar_numero.toString() +
        "," +
        " " +
        place.localidad_nombre.toString() +
        "," +
        " " +
        place.localidad_provincia.toString();
    double distance = await Gps().distanceEvent(direction.toString());
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
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
                    child: FutureBuilder<dynamic>(
                        future: FirebaseStorage().getURLImageEvent(
                            widget.event.evento_nombre.trim()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            String url = snapshot.data!.toString();
                            if (url == "null") {
                              print('143');
                            }
                            return CachedNetworkImage(
                                imageUrl: url, fit: BoxFit.cover);
                            return Image.network(url, fit: BoxFit.cover);
                          }
                          return const CircularProgressIndicator();
                        }),
                  ),

                  /*
                    FutureBuilder<String>(

                        future: FirebaseStorage().getURLImageEvent(
                            widget.event.evento_nombre.trim()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Image.network(snapshot.data!,
                                fit: BoxFit.cover);
                          }
                          return const CircularProgressIndicator();
                        }),
                  ),*/
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
                                      widget.event.evento_nombre,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.mavenPro(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.5,
                                      ),
                                    )),
                                FutureBuilder<double>(
                                    future: getDistanceFromEvent(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        double distanceInKms = 0.0;
                                        double distanceInMts = 0.0;
                                        if (snapshot.data! >= 1000) {
                                          distanceInKms = snapshot.data! / 1000;
                                        } else {
                                          distanceInMts =
                                              snapshot.data!.roundToDouble();
                                        }

                                        return Container(
                                            alignment: Alignment.centerRight,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 15, 0),
                                            child: snapshot.data! >= 1000
                                                ? Text(
                                                    'A' +
                                                        " " +
                                                        distanceInKms
                                                            .round()
                                                            .toString() +
                                                        " " +
                                                        "Km",
                                                    textAlign: TextAlign.right,
                                                    style:
                                                        AppColors().styleBody)
                                                : Text(
                                                    'A' +
                                                        " " +
                                                        distanceInMts
                                                            .round()
                                                            .toString() +
                                                        " " +
                                                        "m",
                                                    textAlign: TextAlign.right,
                                                    style:
                                                        AppColors().styleBody));
                                      }
                                      return CircularProgressIndicator();
                                    }),
                              ],
                            ),
                            const SizedBox(height: 2.5),
                            widget.event.evento_esrepetitivo == 1
                                ? CalendarDays(
                                    idEvento: widget.event.evento_id,
                                  )
                                : CalendarDate(
                                    idEvento: widget.event.evento_id),
                            RowPlace(widget.event),
                            const SizedBox(height: 2.5),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 15.0,
                                    color: Colors.grey.withOpacity(0.65),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  FutureBuilder<Place>(
                                      future: PlacesProvider()
                                          .getPlace(widget.event.evento_lugar),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Text(
                                              snapshot.data!.lugar_nombre
                                                  .toString(),
                                              style: AppColors().styleBody);
                                        }
                                        return const CircularProgressIndicator();
                                      }),
                                  Spacer(),
                                  Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12)),
                                      color: widget.event.evento_esgratis == 1
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    width: 110,
                                    child: widget.event.evento_esgratis == 1
                                        ? Center(
                                            child: Text('Evento gratis',
                                                style: GoogleFonts.mavenPro(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                        : Center(
                                            child: Text('Evento pago',
                                                style: GoogleFonts.mavenPro(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                  ),
                                ],
                              ),
                              /*
                                Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 15.0,
                                      color: Colors.grey.withOpacity(0.65),
                                    ),
                                    const SizedBox(width: 5.0),
                                    FutureBuilder<Place>(
                                        future: PlacesProvider().getPlace(
                                            widget.event.evento_lugar),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Text(
                                                snapshot.data!.lugar_nombre,
                                                style: AppColors().styleBody);
                                          }
                                          return const CircularProgressIndicator();
                                        }),
                                  ],
                                )*/
                            ),
                          ],
                        )),
                  ),
                  flex: 2),
            ],
          )),
    );
  }
}
