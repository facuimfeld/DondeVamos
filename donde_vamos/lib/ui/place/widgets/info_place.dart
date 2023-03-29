// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, sort_child_properties_last

import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';

import 'package:donde_vamos/ui/place/widgets/hour_places.dart';
import 'package:donde_vamos/ui/place/widgets/row_calification.dart';
import 'package:donde_vamos/ui/place/widgets/row_comments.dart';
import 'package:donde_vamos/ui/place/widgets/row_direction.dart';
import 'package:donde_vamos/ui/place/widgets/row_link.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class InfoPlace extends StatefulWidget {
  int idLugar;
  InfoPlace({required this.idLugar});
  @override
  State<InfoPlace> createState() => _InfoPlaceState();
}

class _InfoPlaceState extends State<InfoPlace> {
  double calification = 0.0;

  @override
  void initState() {
    super.initState();
    getCalifPlace();
  }

  Future<void> getCalifPlace() async {
    calification =
        await SuscriptionProvider().getScorePlace(widget.idLugar.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: FutureBuilder<Place>(
                future: PlacesProvider().getPlace(widget.idLugar),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String direction = snapshot.data!.lugar_calle.toString() +
                        " " +
                        snapshot.data!.lugar_numero.toString() +
                        "," +
                        snapshot.data!.localidad_nombre.toString() +
                        "," +
                        snapshot.data!.localidad_provincia.toString();
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                      child: Text(
                                          snapshot.data!.lugar_nombre
                                              .toString(),
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500))),
                                  RowCalificationPlace(
                                      calification: calification.toString()),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                              child: Text(
                                  snapshot.data!.lugar_desc_corta.toString(),
                                  style: AppColors().styleBody)),
                          Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Text(
                                  snapshot.data!.lugar_desc_larga.toString(),
                                  style: AppColors().styleBody)),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: RowDirectionPlace(
                              idPlace: widget.idLugar,
                            ),
                          ),
                          snapshot.data!.lugar_link!.isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  child: RowLink(
                                    url: snapshot.data!.lugar_link!,
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey.withOpacity(0.35),
                                  size: 18.0,
                                ),
                                HourPlaces(idLugar: widget.idLugar),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          RowComments(idPlace: widget.idLugar),
                        ],
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            color: Colors.white,
            width: MediaQuery.of(context).size.width),
        flex: 2);
  }
}
