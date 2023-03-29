import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/comment_place.dart';
import 'package:donde_vamos/resources/comment_provider.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AlertDialogEditCalifPlace extends StatefulWidget {
  CommentPlace comment;
  AlertDialogEditCalifPlace({required this.comment});
  @override
  State<AlertDialogEditCalifPlace> createState() =>
      _AlertDialogEditCalifPlaceState();
}

class _AlertDialogEditCalifPlaceState extends State<AlertDialogEditCalifPlace> {
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

    comment.text = widget.comment.comentario_lugar_texto;
    provisoryValue = widget.comment.comentario_lugar_calificacion;
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
                          widget.comment.comentario_lugar_calificacion =
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
                        widget.comment.comentario_lugar_calificacion =
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
                        widget.comment.comentario_lugar_calificacion =
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
                        widget.comment.comentario_lugar_calificacion =
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
                        widget.comment.comentario_lugar_calificacion =
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
              int idPlace = 0;
              idPlace = widget.comment.lugar;

              data["comentario_lugar_calificacion"] =
                  widget.comment.comentario_lugar_calificacion;
              data["comentario_lugar_texto"] = comment.text;
              data["comentario_lugar_fechayhora"] = formattedDate;
              data["comentario_lugar_usuario"] =
                  await LocalPreferences().getUsername();
              data["comentario_lugar_lugar_id"] = idPlace;

              await CommentProvider().updateComment(data).then((value) async {
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
