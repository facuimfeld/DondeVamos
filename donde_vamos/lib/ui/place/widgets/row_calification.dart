// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowCalificationPlace extends StatefulWidget {
  String calification;
  RowCalificationPlace({required this.calification});

  @override
  State<RowCalificationPlace> createState() => _RowCalificationPlaceState();
}

class _RowCalificationPlaceState extends State<RowCalificationPlace> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 10, 5, 0),
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Icon(Icons.star, color: Colors.yellow, size: 25.0),
            widget.calification == "0.0"
                ? Text("0",
                    style: GoogleFonts.mavenPro(
                        color: Colors.grey.withOpacity(0.25),
                        fontSize: 18,
                        fontWeight: FontWeight.bold))
                : Text(widget.calification,
                    style: GoogleFonts.mavenPro(
                        color: Colors.grey.withOpacity(0.25),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
          ],
        ));
  }
}
