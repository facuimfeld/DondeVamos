// ignore_for_file: sort_child_properties_last, use_build_context_synchronously

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSuscribePlace extends StatefulWidget {
  bool isSuscribe;
  ButtonSuscribePlace({required this.idLugar, required this.isSuscribe});
  int idLugar;

  @override
  State<ButtonSuscribePlace> createState() => _ButtonSuscribePlaceState();
}

class _ButtonSuscribePlaceState extends State<ButtonSuscribePlace> {
  @override
  void initState() {
    super.initState();
    print('id' + widget.idLugar.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String username = await LocalPreferences().getUsername();
        if (widget.isSuscribe == false) {
          //cargar suscripcion
          await SuscriptionProvider()
              .registerSuscriptionPlace(widget.idLugar, username)
              .whenComplete(() async {
            Place place = await PlacesProvider().getPlace(widget.idLugar);
            await Notifications().postSuscriptionPlace(place);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                const Icon(Icons.check, color: Colors.white),
                Text('Suscripcion hecha!',
                    style: GoogleFonts.mavenPro(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            )));
          });
          setState(() {
            widget.isSuscribe = true;
          });
        } else {
          //cancelar suscripcion
          String username = await LocalPreferences().getUsername();
          Place place = await PlacesProvider().getPlace(widget.idLugar);
          await Notifications().deleteSuscriptionPlaceRTBD(place);
          await SuscriptionProvider()
              .deleteSuscriptionPlace(widget.idLugar, username)
              .whenComplete(() {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                const Icon(Icons.check, color: Colors.white),
                Text('Suscripcion eliminada!',
                    style: GoogleFonts.mavenPro(
                        color: Colors.white, fontWeight: FontWeight.w500)),
              ],
            )));
          });
          setState(() {
            widget.isSuscribe = false;
          });
        }

        // SuscriptionProvider()
        //   .registerSuscriptionPlace(widget.idLugar, username);
      },
      child: ClipRRect(
        // ignore: prefer_const_constructors
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10)),
        child: Container(
            child: Center(
                child: widget.isSuscribe
                    ? Text('Cancelar suscripcion',
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0,
                        ))
                    : Text('Suscribirme a este lugar',
                        style: GoogleFonts.mavenPro(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0,
                        ))),
            decoration: BoxDecoration(
              gradient: AppColors().gradient,
            ),
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 1),
      ),
    );
  }
}
