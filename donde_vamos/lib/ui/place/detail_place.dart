// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/local/local_preferences.dart';

import 'package:donde_vamos/models/place.dart';
//import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/place/widgets/button_suscribe_place.dart';
import 'package:donde_vamos/ui/place/widgets/image_place.dart';
import 'package:donde_vamos/ui/place/widgets/info_place.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPlace extends StatefulWidget {
  int idLugar;

  DetailPlace({required this.idLugar});
  @override
  State<DetailPlace> createState() => _DetailPlaceState();
}

class _DetailPlaceState extends State<DetailPlace> {
  bool isSuscribe = false;
  Future<void> isSuscribePlace() async {
    isSuscribe =
        await SuscriptionProvider().verifySuscriptionPlace(widget.idLugar);
    print('IS SUSCRIBE' + isSuscribe.toString());
  }

  Future<void> setLogged() async {
    isLogged = await LocalPreferences().getValueLogged();
    //double calif = await SuscriptionProvider()
    //   .getScoreEvent(widget.idLugar.toString());
    //widget.event.evento_calificacion = calif.toString();
    setState(() {});
    print('IS LOGGED' + isLogged.toString());
  }

  bool isLogged = false;
  @override
  void initState() {
    print('id lugar' + widget.idLugar.toString());
    isSuscribePlace().then((value) {
      setState(() {});
    });
    setLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeInLeft(
          duration: const Duration(milliseconds: 700),
          child: FutureBuilder<Place>(
            future: PlacesProvider().getPlace(widget.idLugar),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImagePlace(snapshot.data!.lugar_nombre.toString()),
                    InfoPlace(idLugar: widget.idLugar),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      bottomNavigationBar: isLogged == true
          ? ButtonSuscribePlace(
              idLugar: widget.idLugar,
              isSuscribe: isSuscribe,
            )
          : const Text(''),
      /*
      bottomNavigationBar: ButtonSuscribePlace(
        idLugar: widget.idLugar,
        isSuscribe: isSuscribe,
      ),*/
    );
  }
}
