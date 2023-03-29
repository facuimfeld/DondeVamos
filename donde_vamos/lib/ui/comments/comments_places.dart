// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/comment_place.dart';
import 'package:donde_vamos/resources/comment_provider.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:donde_vamos/ui/comments/alert_dialog_edit.dart';
import 'package:donde_vamos/ui/comments/alert_dialog_edit_place.dart';
import 'package:donde_vamos/ui/comments/alert_dialog_success.dart';
import 'package:donde_vamos/ui/comments/alert_dialog_success_place.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/place/widgets/alert_dialog_calif_place.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final streamController = StreamController<List<Comment>>();

class CommentsPlaces extends StatefulWidget {
  List<CommentPlace> comments;
  String idPlace;
  String namePlace;
  CommentsPlaces(
      {required this.comments, required this.idPlace, required this.namePlace});

  @override
  State<CommentsPlaces> createState() => _CommentsPlacesState();
}

class _CommentsPlacesState extends State<CommentsPlaces> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
  bool existsCommentUser = false;
  String username = '';
  bool exists = false;
  @override
  void initState() {
    super.initState();
    existsUsername();
  }

  Future<void> existsUsername() async {
    exists = await LocalPreferences().existsKeyUsername();
    if (exists == true) {
      setUsername().whenComplete(() {
        for (int i = 0; i <= widget.comments.length - 1; i++) {
          if (widget.comments[i].usuario == username) {
            setState(() {
              existsCommentUser = true;
            });
          }
        }
        print('exists' + existsCommentUser.toString());
        setState(() {});
      }).then((value) {
        setState(() {});
      });
      widget.comments.sort((a, b) {
        if (a.usuario == username) {
          return a.usuario
              .toString()
              .toLowerCase()
              .compareTo(b.usuario.toString().toLowerCase());
        }

        return b.usuario
            .toString()
            .toLowerCase()
            .compareTo(a.usuario.toString().toLowerCase());
      });
    }
  }

  Future<void> setUsername() async {
    username = await LocalPreferences().getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            return FadeInLeft(
              duration: const Duration(milliseconds: 700),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.star,
                            size: 15.0,
                            color: widget.comments[index]
                                        .comentario_lugar_calificacion ==
                                    1
                                ? Colors.yellow
                                : Colors.yellow),
                        Icon(Icons.star,
                            size: 15.0,
                            color: widget.comments[index]
                                        .comentario_lugar_calificacion ==
                                    2
                                ? Colors.yellow
                                : widget.comments[index]
                                            .comentario_lugar_calificacion <
                                        2
                                    ? Colors.grey
                                    : Colors.yellow),
                        Icon(
                          Icons.star,
                          size: 15.0,
                          color: widget.comments[index]
                                      .comentario_lugar_calificacion ==
                                  3
                              ? Colors.yellow
                              : widget.comments[index]
                                          .comentario_lugar_calificacion <
                                      3
                                  ? Colors.grey
                                  : Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 15.0,
                          color: widget.comments[index]
                                      .comentario_lugar_calificacion ==
                                  4
                              ? Colors.yellow
                              : widget.comments[index]
                                          .comentario_lugar_calificacion <
                                      4
                                  ? Colors.grey
                                  : Colors.yellow,
                        ),
                        Icon(
                          Icons.star,
                          size: 15.0,
                          color: widget.comments[index]
                                      .comentario_lugar_calificacion ==
                                  5
                              ? Colors.yellow
                              : widget.comments[index]
                                          .comentario_lugar_calificacion <
                                      5
                                  ? Colors.grey
                                  : Colors.yellow,
                        )
                      ],
                    ),
                    leading: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.black,
                        child: Center(
                            child: Text(
                                widget.comments[index].usuario.substring(0, 1),
                                style: GoogleFonts.mavenPro(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15.0)))),
                    title: Row(
                      children: [
                        Text(widget.comments[index].usuario,
                            style: GoogleFonts.mavenPro(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w500)),
                        SizedBox(width: 15.0),
                        widget.comments[index].usuario == username
                            ? Row(
                                children: [
                                  SizedBox(width: 5.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppColors().gradient,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        /*
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialogEditCalifPlace(
                                                nameEvent: widget.nameEvent,
                                                comment: widget.comments[index],
                                              );
                                            });*/
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialogEditCalifPlace(
                                                    comment:
                                                        widget.comments[index]);
                                              });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 10.0,
                                          child: Icon(Icons.edit,
                                              size: 12.0, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.0),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Eliminacion de comentario5',
                                                  style: GoogleFonts.mavenPro(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              content: Container(
                                                height: 100,
                                                width: 200,
                                                child: Center(
                                                  child: Text(
                                                      '¿Desea eliminar su comentario?',
                                                      style:
                                                          GoogleFonts.mavenPro(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                ),
                                                color: Colors.white,
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      await CommentProvider()
                                                          .deleteCommentPlace(
                                                              int.parse(widget
                                                                  .idPlace))
                                                          .whenComplete(() {
                                                        showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Eliminacion de comentario',
                                                                    style: GoogleFonts.mavenPro(
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                content: Center(
                                                                    child:
                                                                        Column(
                                                                  children: [
                                                                    Text(
                                                                        'comentario borrado!'),
                                                                  ],
                                                                )),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => Home()));
                                                                      },
                                                                      child: Text(
                                                                          'Aceptar'))
                                                                ],
                                                              );
                                                            });
                                                      });
                                                    },
                                                    child: Text('Si')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancelar')),
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: AppColors().gradient,
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 10.0,
                                        child: Icon(Icons.delete,
                                            size: 12.0, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(''),
                      ],
                    ),
                    subtitle: Text(
                        formatter.format(DateTime.parse(widget
                            .comments[index].comentario_lugar_fechayhora)),
                        style: GoogleFonts.mavenPro(
                            color: Colors.grey.withOpacity(0.25),
                            fontWeight: FontWeight.w500)),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(widget.comments[index].comentario_lugar_texto,
                          style: GoogleFonts.mavenPro(
                              color: Colors.black.withOpacity(0.25),
                              fontWeight: FontWeight.w500))),
                ],
              ),
            );
          }),
      bottomNavigationBar: exists
          ? existsCommentUser
              ? Text('')
              : GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialogCalifPlace(
                              idPlace: widget.idPlace,
                              namePlace: widget.namePlace);
                        });
                  },
                  child: Container(
                    child: Center(
                        child: Text('Calificar lugar',
                            style: GoogleFonts.mavenPro(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0))),
                    decoration: BoxDecoration(
                      gradient: AppColors().gradient,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                )
          : Text(''),
    );
  }
}

class AlertDialogCalification extends StatefulWidget {
  String nameEvent;
  List<Comment> listComments;
  AlertDialogCalification(
      {required this.nameEvent, required this.listComments});

  @override
  State<AlertDialogCalification> createState() =>
      _AlertDialogCalificationState();
}

class _AlertDialogCalificationState extends State<AlertDialogCalification> {
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
              setState(() {
                widget.listComments.add(commentt);
              });
              await SuscriptionProvider()
                  .sendCalification(data)
                  .then((value) async {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialogSuccess();
                    });
                //  Navigator.pop(context);
                /*
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Comments(
                      comments: widget.listComments,
                      idEvent: idE.toString(),
                      nameEvent: widget.nameEvent,
                    ),
                  ),
                );*/
              });
            },
            child: Text('Enviar calificacion')),
      ],
    );
  }
}
