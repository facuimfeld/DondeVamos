import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowCategory extends StatelessWidget {
  String category;
  String subcategory;
  RowCategory({required this.category, required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Row(
          children: [
            Chip(
                backgroundColor: Colors.pink[300],
                label: Text(category,
                    style: GoogleFonts.mavenPro(
                        fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(width: 5.0),
            Chip(
                backgroundColor: Colors.pink[300],
                label: Text(subcategory,
                    style: GoogleFonts.mavenPro(
                        fontWeight: FontWeight.bold, color: Colors.white))),
          ],
        ));
  }
}
