// ignore_for_file: prefer_const_constructors

import 'package:donde_vamos/ui/place/widgets/alert_dialog_calif_place.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageNoComments extends StatelessWidget {
  String namePlace;
  int idPlace;
  MessageNoComments(this.idPlace, this.namePlace);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(namePlace,
          style: GoogleFonts.mavenPro(
              fontSize: 17.0, fontWeight: FontWeight.w500)),
      content: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.6,
          color: Colors.white,
          child: Text(
              'Este lugar todavia no tiene comentarios, se el primero en comentar!',
              style: GoogleFonts.mavenPro(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5)))),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (ctx3) {
                    return AlertDialogCalifPlace(
                        idPlace: idPlace.toString(), namePlace: namePlace);
                  });
            },
            child: Text('Comentar Lugar')),
      ],
    );
  }
}
