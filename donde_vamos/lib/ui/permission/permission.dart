// ignore_for_file: sort_child_properties_last

import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/device/permission_handler.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:permission_handler/permission_handler.dart';

class Permission extends StatelessWidget {
  const Permission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: FadeInLeft(
        duration: Duration(milliseconds: 700),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*
              CircleAvatar(
                radius: 70.0,
                child: Icon(Icons.room, color: Colors.pink, size: 60.0),
                backgroundColor: Colors.white,
              ),*/
              SizedBox(
                height: 200,
                width: 200,
                child: CustomPaint(
                  painter: RingPainter(),
                  child: const Icon(Icons.room, color: Colors.pink, size: 60.0),
                ),
              ),
              Text('¿Dónde estás?',
                  style: GoogleFonts.mavenPro(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                    'Activa tu ubicación para ofrecerte una mejor experiencia en la aplicación',
                    maxLines: 3,
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FadeInLeft(
        duration: const Duration(milliseconds: 700),
        child: GestureDetector(
          onTap: () async {
            var permission = await Permissions().requestGPS();
            if (permission.isGranted) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }
          },
          child: Container(
            color: Colors.pink,
            child: Center(
                child: Text('Activar localizacion',
                    style: GoogleFonts.mavenPro(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold))),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
          ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    //Paint to draw ring shape
    Paint paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    //defining Center of Box
    Offset center = Offset(width / 2, height / 2);
    //defining radius
    double radius = min(width / 3.5, height / 3.5);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
