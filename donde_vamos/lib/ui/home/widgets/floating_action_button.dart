// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:donde_vamos/ui/login/login.dart';
import 'package:donde_vamos/utilities/colors.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingActionButtonHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Container(
        child: Center(
            child: Text('Iniciar Sesion',
                style: GoogleFonts.mavenPro(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0))),
        decoration: BoxDecoration(
            gradient: AppColors().gradient,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        height: 60,
        width: 150,
      ),
    );
  }
}
