// ignore_for_file: prefer_interpolation_to_compose_strings, sort_child_properties_last, use_build_context_synchronously

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/detail_event/widgets/alert_dialog_unavailable_suscription.dart';

import 'package:donde_vamos/ui/detail_event/widgets/button_suscribe_event.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_category.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_comments.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_direction.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_phone.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_place.dart';
import 'package:donde_vamos/ui/detail_event/widgets/row_user.dart';
import 'package:donde_vamos/ui/detail_event/widgets/various_dates.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:donde_vamos/utilities/utilites_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoEvent extends StatefulWidget {
  Event event;
  InfoEvent({required this.event});
  @override
  State<InfoEvent> createState() => _InfoEventState();
}

class _InfoEventState extends State<InfoEvent> {
  bool isLogged = false;
  bool isSuscribe = false;
  bool canComment = false;
  bool enabledSuscription = false;
  @override
  void initState() {
    setLogged();
    isSuscribeEvent().then((value) {
      setState(() {});
    });
    suscriptionEnabled().then((value) {
      setState(() {});
    });
    super.initState();
  }

  Future<void> existComments(List<DateEvent> datesEvents) async {}

  Future<void> isSuscribeEvent() async {
    enabledSuscription = await suscriptionEnabled();
    print('enab' + enabledSuscription.toString());
    isSuscribe =
        await SuscriptionProvider().verifySuscription(widget.event.evento_id);
  }

  Future<bool> suscriptionEnabled() async {
    //verificar si el evento no es repetitivo
    Event event = await EventProvider().getEventByID(widget.event.evento_id);
    List<DateEvent> datesEvents = [];
    bool isEnabledSuscrip = false;
    if (event.evento_esrepetitivo == 0) {
      datesEvents = await DatesProvider().getDatesFromEvent(event.evento_id);
      DateTime now = DateTime.now();
      //contador de veces que la fecha de hoy supera la fecha del evento
      int contveces = 0;
      for (int i = 0; i <= datesEvents.length - 1; i++) {
        DateTime fechaevento = DateTime.parse(datesEvents[i].fecha_evento_dia);

        if (fechaevento.difference(now).inDays > 0 ||
            fechaevento.difference(now).inDays < 0) {
          if (fechaevento.isBefore(now)) {
            contveces++;
          }
        }
      }

      print('contveces' + contveces.toString());

      if (contveces < datesEvents.length) {
        setState(() {
          isEnabledSuscrip = true;
        });
      }
    }

    return isEnabledSuscrip;
  }

  Future<void> setLogged() async {
    isLogged = await LocalPreferences().getValueLogged();
    double calif = await SuscriptionProvider()
        .getScoreEvent(widget.event.evento_id.toString());
    widget.event.evento_calificacion = calif.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.event.evento_nombre,
                              style: GoogleFonts.mavenPro(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500)),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: FutureBuilder<double>(
                                future: SuscriptionProvider().getScoreEvent(
                                    widget.event.evento_id.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    double calif =
                                        snapshot.data!.roundToDouble();
                                    return Row(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.yellow, size: 25.0),
                                        Text(calif.toString(),
                                            style: GoogleFonts.mavenPro(
                                                color: Colors.grey
                                                    .withOpacity(0.25),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    );
                                  }
                                  return const CircularProgressIndicator();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RowPlace(event: widget.event),
                        RowUser(user: widget.event.evento_usuario),
                      ],
                    ),
                  ),

                  RowCategory(
                      category: widget.event.categoria_evento,
                      subcategory: widget.event.subcategoria_evento),
                  Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.fromLTRB(0, 0, 17, 10),
                    child: Text(widget.event.evento_desc_larga,
                        style: AppColors().styleBody),
                  ),

                  // RowPlace(event: widget.event),
                  //  SizedBox(height: 5.0),
                  // RowUser(user: widget.event.evento_usuario),
                  RowDirection(event: widget.event),
                  RowPhone(event: widget.event, isLogged: isLogged),
                  widget.event.evento_esrepetitivo == 0
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_month,
                                  color: Colors.grey.withOpacity(0.25),
                                  size: 18.0),
                              const SizedBox(width: 5.0),
                              FutureBuilder<List<DateEvent>>(
                                  future: DatesProvider().getDatesFromEvent(
                                      widget.event.evento_id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.data!.length == 1) {
                                        return DataTable(
                                            dataRowHeight: 30.0,
                                            headingRowHeight: 16,
                                            horizontalMargin: 10.0,
                                            columnSpacing: 20.0,
                                            columns: [
                                              DataColumn(
                                                  label: Text('Fecha',
                                                      style: AppColors()
                                                          .styleBody)),
                                              DataColumn(
                                                  label: Text('Hora Inicio',
                                                      style: AppColors()
                                                          .styleBody)),
                                              DataColumn(
                                                  label: Text('Hora Fin',
                                                      style: AppColors()
                                                          .styleBody)),
                                            ],
                                            rows: snapshot.data!.map((e) {
                                              return DataRow(cells: [
                                                DataCell(Text(
                                                    e.fecha_evento_dia,
                                                    style:
                                                        AppColors().styleBody)),
                                                DataCell(Text(
                                                    e.fecha_evento_horario_inicio,
                                                    style: AppColors().styleBody)),
                                                DataCell(Text(
                                                    e.fecha_evento_horario_fin,
                                                    style:
                                                        AppColors().styleBody)),
                                              ]);
                                            }).toList());
                                      }
                                      return VariousDates(
                                          dateEvents: snapshot.data!);
                                    }
                                    return const CircularProgressIndicator();
                                  }),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(20, 15, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.calendar_month,
                                  color: Colors.grey.withOpacity(0.25),
                                  size: 18.0),
                              const SizedBox(width: 5.0),
                              FutureBuilder<List<HourEvent>>(
                                  future: DatesProvider()
                                      .getDaysFromEvent(widget.event.evento_id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return DataTable(
                                          dataRowHeight: 30.0,
                                          headingRowHeight: 16,
                                          horizontalMargin: 10.0,
                                          columnSpacing: 20.0,
                                          columns: [
                                            DataColumn(
                                                label: Text('Dia',
                                                    style:
                                                        AppColors().styleBody)),
                                            DataColumn(
                                                label: Text('H.Mañana',
                                                    style:
                                                        AppColors().styleBody)),
                                            DataColumn(
                                                label: Text('H.Tarde',
                                                    style:
                                                        AppColors().styleBody)),
                                          ],
                                          rows: snapshot.data!.map((e) {
                                            return DataRow(cells: [
                                              DataCell(Text(
                                                  UtilitiesEvent().getDay(e
                                                      .horarios_eventos_diadesem),
                                                  style:
                                                      AppColors().styleBody)),
                                              DataCell(Text(
                                                  e.horarios_eventos_desde_m
                                                          .toString() +
                                                      '-' +
                                                      e.horarios_eventos_hasta_m
                                                          .toString(),
                                                  style:
                                                      AppColors().styleBody)),
                                              DataCell(e.horarios_eventos_desde_t
                                                              .toString() ==
                                                          'null' &&
                                                      e.horarios_eventos_hasta_t
                                                              .toString() ==
                                                          'null'
                                                  ? Text('Cerrado',
                                                      style:
                                                          AppColors().styleBody)
                                                  : Text(
                                                      e.horarios_eventos_desde_t
                                                              .toString() +
                                                          '-' +
                                                          e.horarios_eventos_hasta_t
                                                              .toString(),
                                                      style: AppColors()
                                                          .styleBody)),
                                            ]);
                                          }).toList());
                                    }
                                    return const CircularProgressIndicator();
                                  }),
                            ],
                          ),
                        ),

                  RowComments(
                      //datesEvents: DatesProvider().getDatesFromEvent(widget.event.evento_id),
                      nameEvent: widget.event.evento_nombre,
                      idEvento: widget.event.evento_id.toString()),
                  const SizedBox(
                    height: 50.0,
                  ),
                  isLogged == true
                      ? GestureDetector(
                          onTap: () async {
                            if (enabledSuscription == true) {
                              String username =
                                  await LocalPreferences().getNameUser();
                              if (isSuscribe == false) {
                                //agregar suscripcion
                                await SuscriptionProvider()
                                    .registerSuscription(
                                        widget.event.evento_id, username)
                                    .whenComplete(
                                  () async {
                                    await Notifications().postNotificationEmail(
                                        widget.event,
                                        "Suscripcion a un evento",
                                        "Te has suscripto al evento" +
                                            " " +
                                            widget.event.evento_nombre +
                                            ". Recibiras notificaciones por esta via sobre cualquier cambio que acontezca al evento");
                                    await Notifications()
                                        .postSuscriptionEvent(widget.event);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Row(
                                      children: [
                                        const Icon(Icons.check,
                                            color: Colors.white),
                                        Text('Suscripcion hecha!',
                                            style: GoogleFonts.mavenPro(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    )));
                                  },
                                );
                                setState(() {
                                  isSuscribe = true;
                                });

                                // await Notifications()
                                //    .postNotificationEmail(widget.event);
                              } else {
                                //cancelar suscripcion
                                await Notifications().postNotificationEmail(
                                    widget.event,
                                    "Suscripcion eliminada de un evento",
                                    "Has eliminado tu suscripcion al evento" +
                                        " " +
                                        widget.event.evento_nombre +
                                        ". Dejaras de recibir notificaciones por esta via sobre cualquier cambio que acontezca al evento");
                                await Notifications()
                                    .deleteSuscriptionEventRTBD(widget.event);

                                await SuscriptionProvider()
                                    .deleteSuscription(widget.event.evento_id)
                                    .whenComplete(() {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.white),
                                      Text('Suscripcion eliminada!',
                                          style: GoogleFonts.mavenPro(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )));
                                });
                                setState(() {
                                  isSuscribe = false;
                                });
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return const AlertDialogUnavailableSuscription();
                                  });
                            }
                          },
                          child: BottomSuscribeEvent(
                            idEvento: widget.event.evento_id,
                            isSuscribe: isSuscribe,
                          ),
                        )
                      : const Text('')
                ],
              ),
            ),
            color: Colors.white,
            width: MediaQuery.of(context).size.width),
        flex: 2);
  }
}
