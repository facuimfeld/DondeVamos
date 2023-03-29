// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogSuccessPlace extends StatefulWidget {
  AlertDialogSuccessPlace({Key? key}) : super(key: key);

  @override
  State<AlertDialogSuccessPlace> createState() =>
      _AlertDialogSuccessPlaceState();
}

class _AlertDialogSuccessPlaceState extends State<AlertDialogSuccessPlace> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20.0,
                child: Icon(Icons.check, color: Colors.white),
                backgroundColor: Colors.green,
              ),
              SizedBox(height: 10.0),
              Text('Comentario eliminado!',
                  style: GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: Text('Aceptar')),
      ],
    );
  }
}
