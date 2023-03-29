import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const color1 = Color(0xffcf63ff);
  static const color2 = Color(0xfff86d70);
  // String color1 = "cf63ff";
  String colorHover = "4a148c";
  // String color2 = "f86d70";
  String colorPurple = 'aa00ff';
  LinearGradient gradient = const LinearGradient(colors: [color1, color2]);

  //tamaño texto cuerpo tarjeta

  TextStyle styleBody = GoogleFonts.mavenPro(
    fontSize: 13.0,
    color: Colors.grey.withOpacity(0.65),
    fontWeight: FontWeight.w500,
  );
}
