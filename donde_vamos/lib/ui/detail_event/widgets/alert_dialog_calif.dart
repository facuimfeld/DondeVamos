// ignore_for_file: prefer_const_constructors

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/main.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/comments/comments.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AlertDialogCalif extends StatefulWidget {
  String nameEvent;
  String idEvento;
  AlertDialogCalif({required this.idEvento, required this.nameEvent});
  @override
  State<AlertDialogCalif> createState() => _AlertDialogCalifState();
}

class _AlertDialogCalifState extends State<AlertDialogCalif> {
  int calification = 0;
  bool pulsestar1 = false;

  bool pulsestar2 = false;
  TextEditingController comment = TextEditingController();
  bool pulsestar3 = false;
  bool pulsestar4 = false;
  bool pulsestar5 = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.nameEvent, style: GoogleFonts.mavenPro(fontSize: 17.0)),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width * 0.6,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu calificacion', style: GoogleFonts.mavenPro()),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (pulsestar1 == false) {
                        setState(() {
                          calification++;
                          pulsestar1 = !pulsestar1;
                        });
                      } else {
                        setState(() {
                          calification--;
                          pulsestar1 = !pulsestar1;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: pulsestar1 == true
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (pulsestar2 == false) {
                        setState(() {
                          calification = calification + 2;
                          pulsestar2 = !pulsestar2;
                          pulsestar1 = true;
                        });
                      } else {
                        setState(() {
                          calification = calification - 2;
                          pulsestar2 = !pulsestar2;
                          pulsestar1 = false;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: calification >= 2
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (pulsestar3 == false) {
                        setState(() {
                          calification = calification + 3;
                          pulsestar3 = !pulsestar3;
                          pulsestar1 = true;
                          pulsestar2 = true;
                        });
                      } else {
                        setState(() {
                          calification = calification - 3;
                          pulsestar3 = !pulsestar3;
                          pulsestar2 = !pulsestar2;
                          pulsestar1 = !pulsestar1;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: calification >= 3
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (pulsestar4 == false) {
                        setState(() {
                          calification = calification + 4;
                          pulsestar4 = !pulsestar4;
                          pulsestar1 = true;
                          pulsestar2 = true;
                          pulsestar3 = true;
                        });
                      } else {
                        setState(() {
                          calification = calification - 4;
                          pulsestar4 = !pulsestar4;
                          pulsestar3 = !pulsestar3;
                          pulsestar2 = !pulsestar2;
                          pulsestar1 = !pulsestar1;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: calification >= 4
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (pulsestar5 == false) {
                        setState(() {
                          calification = calification + 5;
                          pulsestar5 = !pulsestar5;
                          pulsestar1 = true;
                          pulsestar2 = true;
                          pulsestar3 = true;
                          pulsestar4 = true;
                        });
                      } else {
                        setState(() {
                          calification = calification - 5;
                          pulsestar5 = !pulsestar5;
                          pulsestar4 = !pulsestar4;
                          pulsestar3 = !pulsestar3;
                          pulsestar2 = !pulsestar2;
                          pulsestar1 = !pulsestar1;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: calification == 5
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Text('Comentarios', style: GoogleFonts.mavenPro()),
              Card(
                  color: Colors.white,
                  child: TextField(
                    controller: comment,
                    maxLines: 5, //or null
                    decoration: const InputDecoration.collapsed(
                        hintText: "Ingresa un comentario.."),
                  ))
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
              Map<String, dynamic> data = {};
              data["comentario_evento_evento_id"] =
                  await EventProvider().getIDEvent(widget.nameEvent);
              data["comentario_evento_calificacion"] = calification;
              data["comentario_evento_texto"] = comment.text;
              data["comentario_evento_fechayhora"] = formattedDate;
              data["comentario_evento_usuario"] =
                  await LocalPreferences().getUsername();
              Comment commentt = Comment(
                comentario_evento_calificacion: calification,
                comentario_evento_evento_id:
                    data["comentario_evento_evento_id"],
                comentario_evento_fechayhora: DateTime.now(),
                comentario_evento_texto: comment.text,
                comentario_evento_usuario:
                    await LocalPreferences().getUsername(),
                comentario_evento_id: 1,
              );
              await SuscriptionProvider()
                  .sendCalification(data)
                  .whenComplete(() async {
                Event event = await EventProvider()
                    .getEventByID(int.parse(widget.idEvento));
/*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailEvent(event: event)),
                );*/
                navigatorKey.currentState!.push(MaterialPageRoute(
                    builder: (context) => DetailEvent(event: event)));
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  /*
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      Text('Comentario registrado!',
                          style: GoogleFonts.mavenPro(fontSize: 13.5)),
                    ],
                  )));*/
                  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
                      content: Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      Text('Comentario registrado!',
                          style: GoogleFonts.mavenPro(fontSize: 13.5)),
                    ],
                  )));
                });
              });
/*
              await SuscriptionProvider()
                  .sendCalification(data)
                  .then((value) async {
                Event event = await EventProvider()
                    .getEventByID(int.parse(widget.idEvento));


                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailEvent(event: event)),
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    Text('Comentario registrado!',
                        style: GoogleFonts.mavenPro(fontSize: 13.5)),
                  ],
                )));
                
              });*/
            },
            child: Text('Enviar calificacion')),
      ],
    );
  }
}
