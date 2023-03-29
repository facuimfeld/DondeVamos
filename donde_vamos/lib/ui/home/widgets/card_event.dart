// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:donde_vamos/device/gps.dart';
import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
//import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/home/widgets/calendar_date.dart';
import 'package:donde_vamos/ui/home/widgets/calendar_days.dart';
import 'package:donde_vamos/ui/home/widgets/row_place.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class CardEvent extends StatefulWidget {
  Event event;
  CardEvent(this.event);

  @override
  State<CardEvent> createState() => _CardEventState();
}

class _CardEventState extends State<CardEvent> {
  @override
  void initState() {
    print('134134');
    super.initState();
  }

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
                    child: FutureBuilder<String>(
                        future: FirebaseStorage().getURLImageEvent(
                            widget.event.evento_nombre.trim()),
                        builder: (context, snapshot) {
                          bool hasData = true;
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (!snapshot.hasData) {
                              hasData = false;
                            }
                            if (hasData == true) {
                              return Image.network(snapshot.data!.toString(),
                                  fit: BoxFit.cover);
                            }
                            return Image.network(
                                'https://diccionarioactual.com/wp-content/uploads/2017/10/disponible-768x768.png',
                                fit: BoxFit.cover);
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
                                    widget.event.evento_nombre,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.mavenPro(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 0),
                                    child: FutureBuilder<double>(
                                        future: getDistanceFromEvent(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            double distance = snapshot.data!;
                                            if (snapshot.data! > 1000) {
                                              distance = snapshot.data! / 1000;
                                            }
                                            if (snapshot.data! > 1000) {
                                              //distancia en kms
                                              return Text(
                                                  'A' +
                                                      " " +
                                                      distance
                                                          .round()
                                                          .toString() +
                                                      "km",
                                                  style: AppColors().styleBody);
                                            }
                                            //distancia en metros
                                            return Text(
                                                'A' +
                                                    " " +
                                                    distance
                                                        .round()
                                                        .toString() +
                                                    "m",
                                                style: AppColors().styleBody);
                                          }
                                          return CircularProgressIndicator();
                                        })),
                              ],
                            ),
                            widget.event.evento_esrepetitivo == 1
                                ? CalendarDays(
                                    idEvento: widget.event.evento_id,
                                  )
                                : CalendarDate(
                                    idEvento: widget.event.evento_id),
                            RowPlace(widget.event),
                            Container(
                                margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child: Row(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        future: PlacesProvider().getPlace(
                                            widget.event.evento_lugar),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            String lugar = snapshot
                                                .data!.lugar_nombre!
                                                .replaceAll(
                                                    'Anfiteatro', 'Anf.');
                                            return Text(lugar,
                                                style: AppColors().styleBody);
                                          }
                                          return const CircularProgressIndicator();
                                        }),
                                    Spacer(),
                                    Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: widget.event.evento_esgratis == 1
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      width: 100,
                                      child: widget.event.evento_esgratis == 1
                                          ? Center(
                                              child: Text('Evento gratis',
                                                  style: GoogleFonts.mavenPro(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold)))
                                          : Center(
                                              child: Text('Evento pago',
                                                  style: GoogleFonts.mavenPro(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                    ),
                                    SizedBox(width: 5.0),
                                  ],
                                )),
                            widget.event.evento_esgratis == 1
                                ? Center(
                                    child: Text('Evento gratis',
                                        style: GoogleFonts.mavenPro(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)))
                                : Center(
                                    child: Text('Evento pago',
                                        style: GoogleFonts.mavenPro(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold))),
                          ],
                        )),
                  ),
                  flex: 2),
            ],
          )),
    );
  }
}
