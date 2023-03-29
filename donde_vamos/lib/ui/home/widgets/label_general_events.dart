import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelGeneralEvents extends StatelessWidget {
  const LabelGeneralEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(20, 30, 0, 0),
            child: Text('Próximos eventos',
                style: GoogleFonts.mavenPro(
                    fontSize: 16.0, fontWeight: FontWeight.w500))),
      ],
    );
  }
}
