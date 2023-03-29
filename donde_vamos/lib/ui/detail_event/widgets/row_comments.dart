import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/resources/comment_provider.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/comments/comments.dart';
import 'package:donde_vamos/ui/detail_event/widgets/alert_dialog_calif.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RowComments extends StatefulWidget {
  String idEvento;
  String nameEvent;

  RowComments({required this.idEvento, required this.nameEvent});

  @override
  State<RowComments> createState() => _RowCommentsState();
}

class _RowCommentsState extends State<RowComments> {
  bool canComment = false;
  bool isLogged = false;
  @override
  void initState() {
    super.initState();
    setLogged();
    getDatesFromEvent();
  }

  Future<void> setLogged() async {
    isLogged = await LocalPreferences().getValueLogged();
    print('is logged' + isLogged.toString());
  }

  Future<void> getDatesFromEvent() async {
    List<DateEvent> datesEvents =
        await DatesProvider().getDatesFromEvent(int.parse(widget.idEvento));
    DateTime now = DateTime.now();
    print('dates events length' + datesEvents.length.toString());
    if (datesEvents.isNotEmpty) {
      for (int i = 0; i <= datesEvents.length - 1; i++) {
        DateTime fechaEvent = DateTime.parse(datesEvents[i].fecha_evento_dia);
        bool sameDate = Dates().isSameDate(fechaEvent);
        if (sameDate == true) {
          TimeOfDay timeEventStart = TimeOfDay(
              hour: int.parse(
                  datesEvents[i].fecha_evento_horario_inicio.substring(0, 2)),
              minute: int.parse(
                  datesEvents[i].fecha_evento_horario_fin.substring(3, 4)));
          int hourE = int.parse(
              datesEvents[i].fecha_evento_horario_inicio.substring(0, 2));
          int minE = int.parse(
              datesEvents[i].fecha_evento_horario_inicio.substring(3, 5));
          print('MINE' +
              datesEvents[i].fecha_evento_horario_inicio.substring(3, 5));
          if (DateTime.now().minute >= minE && DateTime.now().hour >= hourE) {
            setState(() {
              canComment = true;
            });
          }
        } else {
          if (fechaEvent.isBefore(now)) {
            setState(() {
              canComment = true;
            });
          }
        }
      }
    } else {
      setState(() {
        canComment = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.comment,
              color: Colors.grey.withOpacity(0.25), size: 18.0),
          SizedBox(width: 5.0),
          FutureBuilder<List<Comment>>(
              future:
                  SuscriptionProvider().getCommentsFromEvent(widget.idEvento),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    if (canComment == false) {
                      return GestureDetector(
                        onTap: () {
                          showMessageAvailability(context);
                        },
                        child: Text('Comentarios inhabilitados',
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.25),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 5, 15, 0),
                                title: Text(widget.nameEvent,
                                    style: GoogleFonts.mavenPro(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w500)),
                                content: SizedBox(
                                  height: 100,
                                  width: 600,
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              'Este evento no tiene comentarios registrados todavía. ¡Se el primero en comentar!',
                                              style: GoogleFonts.mavenPro(
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.w400)),
                                        ]),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (isLogged == true) {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialogCalif(
                                                  idEvento: widget.idEvento,
                                                  nameEvent: widget.nameEvent,
                                                );
                                              });
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: Text('Alerta'),
                                                  content: Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: Center(
                                                      child: Text(
                                                          'Para dejar un comentario en un evento debes iniciar sesion con tu cuenta primero'),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      },
                                      child: Text('Comentar evento')),
                                ],
                              );
                            });
                      },
                      child: Text('Sin comentarios',
                          style: TextStyle(
                              color: Colors.grey.withOpacity(0.25),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500)),
                    );
                  } else {
                    List<Comment> listComments = snapshot.data!;
                    return FutureBuilder<int>(
                        future: CommentProvider()
                            .getComments(int.parse(widget.idEvento)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Comments(
                                                comments: listComments,
                                                idEvent: widget.idEvento,
                                                nameEvent: widget.nameEvent,
                                              ))).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: snapshot.data! > 1
                                    ? Text(
                                        snapshot.data!.toString() +
                                            ' ' +
                                            'comentarios',
                                        style: TextStyle(
                                            color:
                                                Colors.blue.withOpacity(0.40),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold))
                                    : snapshot.data == 1
                                        ? Text(
                                            snapshot.data!.toString() +
                                                ' ' +
                                                'comentario',
                                            style: TextStyle(
                                                color: Colors.blue
                                                    .withOpacity(0.40),
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold))
                                        : Text('0' + ' ' + 'comentarios',
                                            style: TextStyle(
                                                color: Colors.blue
                                                    .withOpacity(0.40),
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold)));
                          }
                          return CircularProgressIndicator(
                            color: Colors.blue.withOpacity(0.3),
                          );
                        });
                  }
                }
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }

  void showMessageAvailability(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: SizedBox(
              height: 100,
              width: 300,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'La adicion de comentarios y calificaciones se habilitaran una vez pase la primer fecha del evento',
                          style: GoogleFonts.mavenPro(
                              fontSize: 19.0, fontWeight: FontWeight.w400)),
                    ]),
              ),
            ),
          );
        });
  }
}
