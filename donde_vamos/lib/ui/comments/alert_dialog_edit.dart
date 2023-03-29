// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AlertDialogEditCalif extends StatefulWidget {
  Comment comment;
  String nameEvent;
  AlertDialogEditCalif({required this.nameEvent, required this.comment});

  @override
  State<AlertDialogEditCalif> createState() => _AlertDialogEditCalifState();
}

class _AlertDialogEditCalifState extends State<AlertDialogEditCalif> {
  bool pulsestar1 = false;
  TextEditingController comment = TextEditingController();
  bool pulsestar2 = false;
  bool pulsestar3 = false;
  bool pulsestar4 = false;
  bool pulsestar5 = false;
  List<Widget> stars = [];
  int provisoryValue = 0;
  @override
  void initState() {
    super.initState();
    print('calif' + widget.comment.comentario_evento_calificacion.toString());
    comment.text = widget.comment.comentario_evento_texto;
    provisoryValue = widget.comment.comentario_evento_calificacion;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edicion de calificacion',
          style: GoogleFonts.mavenPro(fontSize: 17.0)),
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
                      if (provisoryValue > 1) {
                        setState(() {
                          provisoryValue = 1;
                          widget.comment.comentario_evento_calificacion =
                              provisoryValue;
                        });
                      }
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: provisoryValue >= 1
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        provisoryValue = 2;
                        widget.comment.comentario_evento_calificacion =
                            provisoryValue;
                      });
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: provisoryValue > 2 || provisoryValue == 2
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        provisoryValue = 3;
                        widget.comment.comentario_evento_calificacion =
                            provisoryValue;
                      });
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: provisoryValue > 3 || provisoryValue == 3
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        provisoryValue = 4;
                        widget.comment.comentario_evento_calificacion =
                            provisoryValue;
                      });
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: provisoryValue > 4 || provisoryValue == 4
                          ? Colors.yellow
                          : Colors.grey.withOpacity(0.30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        provisoryValue = 5;
                        widget.comment.comentario_evento_calificacion =
                            provisoryValue;
                      });
                    },
                    child: Icon(
                      Icons.star_border_outlined,
                      color: provisoryValue > 5 || provisoryValue == 5
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
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
              Map<String, dynamic> data = {};
              int idEvento = 0;
              idEvento = await EventProvider().getIDEvent(widget.nameEvent);
              data["comentario_evento_evento_id"] = idEvento;
              data["comentario_evento_calificacion"] =
                  widget.comment.comentario_evento_calificacion;
              data["comentario_evento_texto"] = comment.text;
              data["comentario_evento_fechayhora"] = formattedDate;
              data["comentario_evento_usuario"] =
                  await LocalPreferences().getUsername();
              Comment commentt = Comment(
                comentario_evento_calificacion:
                    widget.comment.comentario_evento_calificacion,
                comentario_evento_evento_id:
                    data["comentario_evento_evento_id"],
                comentario_evento_fechayhora: DateTime.now(),
                comentario_evento_texto: comment.text,
                comentario_evento_usuario:
                    await LocalPreferences().getUsername(),
                comentario_evento_id: await SuscriptionProvider()
                    .searchIDCommentByUsernameAndIDEvent(idEvento),
              );

              await SuscriptionProvider()
                  .updateCalification(data)
                  .then((value) async {
                showDialog(
                    context: context,
                    builder: (ctx) {
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
                                Text('Calificacion actualizada!',
                                    style: GoogleFonts.mavenPro(
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              },
                              child: Text('Aceptar')),
                        ],
                      );
                    });
              });
            },
            child: Text('Actualizar comentario')),
      ],
    );
  }
}
