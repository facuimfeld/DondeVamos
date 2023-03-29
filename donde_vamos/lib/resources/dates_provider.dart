import 'dart:convert';

import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:http/http.dart' as http;

class DatesProvider {
  //Obtener fechas de un evento unico
  Future<List<DateEvent>> getDatesFromEvent(int fecha_evento_id_evento) async {
    List<DateEvent> dateevents = [];

    String url = 'http://10.0.3.2:8000/api/fechas-evento/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["fecha_evento_id_evento"] == fecha_evento_id_evento) {
          DateEvent dateevent = DateEvent.fromJSON(jsonData[i]);
          dateevents.add(dateevent);
        }
      }
    }

    return dateevents;
  }

  //Obtener dias y horarios de un evento repetitivo
  Future<List<HourEvent>> getDaysFromEvent(
      int horarios_evento_id_evento) async {
    List<HourEvent> hoursevents = [];

    String url = 'http://10.0.3.2:8000/api/horarios-evento/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["horarios_evento_id_evento"] ==
            horarios_evento_id_evento) {
          HourEvent hourevent = HourEvent.fromJSON(jsonData[i]);
          hoursevents.add(hourevent);
        }
      }
    }
    return hoursevents;
  }

  //calcular fecha proxima
  Future<DateTime> getComingDate(int idEvento) async {
    List<DateEvent> datesEvents =
        await DatesProvider().getDatesFromEvent(idEvento);
    //print('dates ev' + datesEvents[0].fecha_evento_dia);
    DateTime now = DateTime.now();
    DateTime auxDateEvent = DateTime.now();

    int i = 0;
    while (i <= datesEvents.length - 1) {
      DateTime dateEvent = DateTime.parse(datesEvents[i].fecha_evento_dia);
      print('DATE EVENT' + dateEvent.toString());
      print('DATE NOW' + DateTime.now().toString());
      if (now.difference(dateEvent).inDays <= 0) {
        print('a2');
        auxDateEvent = dateEvent;
        i = 99999999999;
      } else {
        i++;
      }
    }

    print('auxdateev' + auxDateEvent.toString());

    return auxDateEvent;
  }
}
