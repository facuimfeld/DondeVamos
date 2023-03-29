import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelNearbyEvents extends StatelessWidget {
  const LabelNearbyEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
        child: Text('Eventos mas cercanos',
            style: GoogleFonts.mavenPro(
                fontSize: 16.0, fontWeight: FontWeight.w500)));
  }
}
