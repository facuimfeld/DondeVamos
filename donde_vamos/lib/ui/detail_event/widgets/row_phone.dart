import 'package:donde_vamos/device/email.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowPhone extends StatefulWidget {
  Event event;
  bool isLogged;
  RowPhone({required this.event, required this.isLogged});

  @override
  State<RowPhone> createState() => _RowPhoneState();
}

class _RowPhoneState extends State<RowPhone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.email, color: Colors.grey.withOpacity(0.25), size: 18.0),
          const SizedBox(width: 5.0),
          GestureDetector(
            onTap: () async {
              widget.isLogged
                  ? Email().sendMail(widget.event.evento_contacto)
                  : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Inicia sesion con tu cuenta para acceder al correo')));
            },
            child: Text(widget.event.evento_contacto,
                style: GoogleFonts.mavenPro(
                    //decoration: TextDecoration.underline,
                    fontSize: 13.0,
                    color: Colors.blue.withOpacity(0.6),
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
