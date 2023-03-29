// ignore_for_file: sort_child_properties_last

import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSuscribeEvent extends StatefulWidget {
  int idEvento;
  bool isSuscribe;
  BottomSuscribeEvent({required this.idEvento, required this.isSuscribe});

  @override
  State<BottomSuscribeEvent> createState() => _BottomSuscribeEventState();
}

class _BottomSuscribeEventState extends State<BottomSuscribeEvent> {
  bool enabledSuscription = false;
  @override
  void initState() {
    getEnabledFlag();
    super.initState();
  }

  Future<void> getEnabledFlag() async {
    enabledSuscription = await suscriptionEnabled();
  }

  Future<bool> suscriptionEnabled() async {
    //verificar si el evento no es repetitivo
    Event event = await EventProvider().getEventByID(widget.idEvento);
    List<DateEvent> datesEvents = [];

    if (event.evento_esrepetitivo == 0) {
      datesEvents = await DatesProvider().getDatesFromEvent(event.evento_id);
      DateTime now = DateTime.now();
      //contador de veces que la fecha de hoy supera la fecha del evento
      int contveces = 0;
      for (int i = 0; i <= datesEvents.length - 1; i++) {
        DateTime fechaevento = DateTime.parse(datesEvents[i].fecha_evento_dia);
        print('fecha evento' + datesEvents[i].fecha_evento_dia);
        if (fechaevento.difference(now).inDays > 0 ||
            fechaevento.difference(now).inDays < 0) {
          if (fechaevento.isBefore(now)) {
            contveces++;
          }
        }
      }

      if (contveces < datesEvents.length) {
        setState(() {
          enabledSuscription = true;
        });
      }
    } else {
      setState(() {
        enabledSuscription = true;
      });
    }
    print('enabled Suscription123123 ' + enabledSuscription.toString());
    return enabledSuscription;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // ignore: prefer_const_constructors
      borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10)),
      child: Container(
          child: Center(
              child: enabledSuscription == true
                  ? widget.isSuscribe == false
                      ? Text('Suscribirme a este evento',
                          style: GoogleFonts.mavenPro(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ))
                      : Text('Cancelar Suscripcion',
                          style: GoogleFonts.mavenPro(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ))
                  : Text('Suscripcion no disponible',
                      style: GoogleFonts.mavenPro(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18.0,
                      ))),
          decoration: BoxDecoration(
            gradient: enabledSuscription == true ? AppColors().gradient : null,
            color: enabledSuscription == true
                ? null
                : Colors.grey.withOpacity(0.70),
          ),
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width * 1),
    );
  }
}
