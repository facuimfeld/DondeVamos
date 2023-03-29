import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogUnavailableSuscription extends StatelessWidget {
  const AlertDialogUnavailableSuscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Suscripcion no disponible',
          style: GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
      content: SizedBox(
          height: 150,
          width: 300,
          child: Center(
              child: Text(
                  'La suscripcion al evento no esta disponible porque el evento ya sucedio',
                  style: GoogleFonts.mavenPro(fontWeight: FontWeight.w500)))),
    );
  }
}
