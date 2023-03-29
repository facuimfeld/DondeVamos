// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:donde_vamos/device/gps.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/date.dart';

import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:donde_vamos/utilities/utilites_events.dart';
import 'package:flutter/material.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventProvider {
  //Buscar evento por id
  Future<Event> getEventByID(int id) async {
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    Event event = Event(
      categoria_evento: '',
      evento_aforo: 0,
      evento_estado: '',
      evento_calificacion: '',
      evento_categoria: 0,
      evento_compra_url: '',
      evento_contacto: '',
      evento_desc_corta: '',
      evento_desc_larga: '',
      evento_esgratis: 0,
      evento_esrepetitivo: 1,
      evento_id: 0,
      evento_lugar: 0,
      evento_nombre: '',
      evento_subcategoria: 1,
      evento_usuario: '',
      subcategoria_evento: '',
    );
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["evento_id"] == id) {
          event = Event.fromJSON(jsonData[i]);
        }
      }
    }

    print('evento' + event.evento_nombre);
    return event;
  }

  //obtener los proximos eventos a la fecha actual
  Future<List<Event>> getUpcomingEvents() async {
    List<Event> events = [];
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      Map<int, String> days = {
        1: 'Lunes',
        2: 'Martes',
        3: 'Miercoles',
        4: 'Jueves',
        5: 'Viernes',
        6: 'Sabado',
        7: 'Domingo'
      };
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      DateTime currentDay = DateTime.now();
      //String stringToday = days[currentDay.weekday].toString();
      int intDayToday = currentDay.day;
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Event event = Event.fromJSON(jsonData[i]);
        bool include = false;
        Place place = await PlacesProvider().getPlace(event.evento_lugar);
        double distanceEvent = await Gps().distanceEvent(
            place.lugar_calle.toString() +
                "," +
                " " +
                place.lugar_numero.toString() +
                " " +
                place.localidad_nombre.toString() +
                " " +
                place.localidad_provincia.toString());
        double distanceLocation = await LocalPreferences().getDistance();
        if (event.evento_esrepetitivo == 1) {
          List<HourEvent> hoursEvents =
              await DatesProvider().getDaysFromEvent(event.evento_id);
          for (int i = 0; i <= hoursEvents.length - 1; i++) {
            String charDayEvent =
                Dates().getCharDay(hoursEvents[i].horarios_eventos_diadesem);
            int intCharDayEvent = returnNumDayEvent(charDayEvent);
            print('distnace event' + distanceEvent.toString());
            if (intCharDayEvent > intDayToday) {
              include = true;
            }
          }

          if (include == true) {
            events.add(event);
          }
        } else {
          List<DateEvent> datesEvents =
              await DatesProvider().getDatesFromEvent(event.evento_id);

          for (int i = 0; i <= datesEvents.length - 1; i++) {
            DateTime dayEvent = DateTime.parse(datesEvents[i].fecha_evento_dia);
            if (dayEvent.isAfter(currentDay)) {
              include = true;
            }
          }
          if (include == true) {
            events.add(event);
          }
        }
      }
    }

    return events;
  }

  int returnNumDayEvent(String charDay) {
    int intCharDay = 0;
    switch (charDay) {
      case 'L':
        intCharDay = 1;
        break;
      case 'M':
        intCharDay = 2;
        break;
      case 'X':
        intCharDay = 3;
        break;
      case 'J':
        intCharDay = 4;
        break;
      case 'V':
        intCharDay = 5;
        break;
      case 'S':
        intCharDay = 6;
        break;
      case 'D':
        intCharDay = 7;
        break;
    }
    return intCharDay;
  }

  //obtener eventos que se realicen en un lugar a menos de 2kms de la ubicacion del usuario
  Future<List<Event>> getNearbyEvents() async {
    List<Event> events = [];
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Event event = Event.fromJSON(jsonData[i]);
        print('evento' + event.evento_nombre);
        //obtengo el lugar donde se hace el evento
        Place place = await PlacesProvider().getPlace(event.evento_lugar);
        //armo el string de direccion del lugar
        String direction = place.lugar_calle.toString() +
            " " +
            place.lugar_numero.toString() +
            "," +
            " " +
            place.localidad_nombre.toString() +
            "," +
            " " +
            place.localidad_provincia.toString();

        //obtener la distancia a la que se encuentra el lugar
        double distance = await Gps().distanceEvent(direction);
        double distanceInKms = distance / 1000;
        double distanceDefault = await LocalPreferences().getDistance();
        bool include = false;
        //Obtener fecha de evento
        if (event.evento_esrepetitivo == 0) {
          List<DateEvent> datesEvents =
              await DatesProvider().getDatesFromEvent(event.evento_id);
          for (int i = 0; i <= datesEvents.length - 1; i++) {
            DateTime fechaEvento =
                DateTime.parse(datesEvents[i].fecha_evento_dia);
            DateTime currentDay = DateTime.now();
            if (fechaEvento.isAfter(currentDay)) {
              include = true;
            }
          }
        } else {
          Map<String, int> days = {
            'L': 1,
            'M': 2,
            'X': 3,
            'J': 4,
            'V': 5,
            'S': 6,
            'D': 7,
          };
          DateTime currentDay = DateTime.now();
          List<HourEvent> hoursEvents =
              await DatesProvider().getDaysFromEvent(event.evento_id);
          for (int i = 0; i <= hoursEvents.length - 1; i++) {
            int nroDiaEvento =
                days[hoursEvents[i].horarios_eventos_diadesem.toString()]!;
            print('curr day' + currentDay.weekday.toString());
            print('nro dia ev' + nroDiaEvento.toString());
            if (nroDiaEvento != currentDay.weekday) {
              include = true;
            }
          }
        }
        if (distanceInKms <= distanceDefault && include == true) {
          events.add(event);
        } else {
          print('ev ' + event.evento_nombre);
        }
      }
    }

    print('events' + events.length.toString());
    return events;
  }

  Future<int> getIDEvent(String nameEvent) async {
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    int id = 0;
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["evento_nombre"] == nameEvent) {
          id = jsonData[i]["evento_id"];
        }
      }
    }
    return id;
  }

  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Event event = Event.fromJSON(jsonData[i]);
        Place place = await PlacesProvider().getPlace(event.evento_lugar);
        String direction = place.lugar_calle.toString() +
            " " +
            place.lugar_numero.toString() +
            "," +
            " " +
            place.localidad_nombre.toString() +
            "," +
            " " +
            place.localidad_provincia.toString();
        double distance = await Gps().distanceEvent(direction);
        double distanceInKms = distance / 1000;
        double distanceDefault = await LocalPreferences().getDistance();
        if (distanceInKms > distanceDefault) {
          events.add(event);
        }
      }
    }
    return events;
  }

  //peticion para traer eventos actuales
  Future<List<Event>> getCurrentEventsOfDay() async {
    String url = 'http://10.0.3.2:8000/api/eventos/';
    List<Event> events = [];
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Event event = Event.fromJSON(jsonData[i]);

        if (event.evento_esrepetitivo == 0) {
          //obtener las fechas en la que se desarrolla el evento no repetitivo
          List<DateEvent> datesEvents =
              await DatesProvider().getDatesFromEvent(event.evento_id);

          //obtener el dia de hoy
          DateTime dayNow = DateTime.now();
          String monthNow = '';
          String dayNowString = '';
          if (dayNow.month < 10) {
            monthNow = '0' + dayNow.month.toString();
          } else {
            monthNow = dayNow.month.toString();
          }
          bool include = false;
          if (dayNow.day < 10) {
            dayNowString = '0' + dayNow.day.toString();
          } else {
            dayNowString = dayNow.day.toString();
          }

          String formattedDay =
              dayNow.year.toString() + '-' + monthNow + '-' + dayNowString;
          for (int j = 0; j <= datesEvents.length - 1; j++) {
            if (datesEvents[j].fecha_evento_dia == formattedDay) {
              include = true;
              // break;
            }
          }

          if (include == true) {
            events.add(event);
            print('evento agregado' + event.evento_nombre);
          }
        } else {
          //si es repetitivo se obtienen los dias en los que se desarrolla el evento
          List<HourEvent> hoursEvents =
              await DatesProvider().getDaysFromEvent(event.evento_id);

          //obtener dia de hoy
          Map<int, String> days = {
            1: 'Lunes',
            2: 'Martes',
            3: 'Miercoles',
            4: 'Jueves',
            5: 'Viernes',
            6: 'Sabado',
            7: 'Domingo'
          };

          Map<String, String> daysEvent = {
            'L': 'Lunes',
            'M': 'Martes',
            'X': 'Miercoles',
            'J': 'Jueves',
            'V': 'Viernes',
            'S': 'Sabado',
            'D': 'Domingo'
          };
          DateTime date = DateTime.now();

          String dateToday = days[date.weekday].toString();

          for (int k = 0; k <= hoursEvents.length - 1; k++) {
            String dayEvent =
                daysEvent[hoursEvents[k].horarios_eventos_diadesem.toString()]
                    .toString();
            DateTime now = DateTime.now();
            String timeEventDesdeM = '';
            String timeEventHastaM = '';
            String timeEventDesdeT = '';
            String timeEventHastaT = '';
            TimeOfDay? timeDayEventDesdeM;
            TimeOfDay? timeDayEventHastaM;
            TimeOfDay? timeDayEventDesdeT;
            TimeOfDay? timeDayEventHastaT;
            if (hoursEvents[k].horarios_eventos_desde_m != null &&
                hoursEvents[k].horarios_eventos_hasta_m != null &&
                hoursEvents[k].horarios_eventos_desde_t != null &&
                hoursEvents[k].horarios_eventos_hasta_t != null) {
              timeEventDesdeM = hoursEvents[k].horarios_eventos_desde_m;
              timeEventHastaM = hoursEvents[k].horarios_eventos_hasta_m;
              timeEventDesdeT = hoursEvents[k].horarios_eventos_desde_t;
              timeEventHastaT = hoursEvents[k].horarios_eventos_hasta_t;

              timeDayEventDesdeM = TimeOfDay(
                  hour: int.parse(timeEventDesdeM.substring(0, 2)),
                  minute: int.parse(timeEventDesdeM.substring(3, 5)));

              timeDayEventHastaM = TimeOfDay(
                hour: int.parse(timeEventHastaM.substring(0, 2)),
                minute: int.parse(timeEventHastaM.substring(3, 5)),
              );

              timeDayEventDesdeT = TimeOfDay(
                hour: int.parse(timeEventDesdeT.substring(0, 2)),
                minute: int.parse(timeEventDesdeT.substring(3, 5)),
              );

              timeDayEventHastaT = TimeOfDay(
                hour: int.parse(timeEventHastaT.substring(0, 2)),
                minute: int.parse(timeEventHastaT.substring(3, 5)),
              );
            } else {
              if (hoursEvents[k].horarios_eventos_desde_m == null &&
                  hoursEvents[k].horarios_eventos_hasta_m == null &&
                  hoursEvents[k].horarios_eventos_desde_t != null &&
                  hoursEvents[k].horarios_eventos_hasta_t != null) {
                timeEventDesdeT = hoursEvents[k].horarios_eventos_desde_t;
                timeEventHastaT = hoursEvents[k].horarios_eventos_hasta_t;

                timeDayEventDesdeT = TimeOfDay(
                  hour: int.parse(timeEventDesdeT.substring(0, 2)),
                  minute: int.parse(timeEventDesdeT.substring(3, 5)),
                );

                timeDayEventHastaT = TimeOfDay(
                  hour: int.parse(timeEventHastaT.substring(0, 2)),
                  minute: int.parse(timeEventHastaT.substring(3, 5)),
                );
              }
              if (hoursEvents[k].horarios_eventos_desde_m != null &&
                  hoursEvents[k].horarios_eventos_hasta_m != null &&
                  hoursEvents[k].horarios_eventos_desde_t == null &&
                  hoursEvents[k].horarios_eventos_hasta_t == null) {
                timeEventDesdeM = hoursEvents[k].horarios_eventos_desde_m;
                timeEventHastaM = hoursEvents[k].horarios_eventos_hasta_m;

                timeDayEventDesdeM = TimeOfDay(
                    hour: int.parse(timeEventDesdeM.substring(0, 2)),
                    minute: int.parse(timeEventDesdeM.substring(3, 5)));

                timeDayEventHastaM = TimeOfDay(
                  hour: int.parse(timeEventHastaM.substring(0, 2)),
                  minute: int.parse(timeEventHastaM.substring(3, 5)),
                );
              }
            }

            TimeOfDay dayNow = TimeOfDay(hour: now.hour, minute: now.minute);
            double? timeEventDesdeMDouble;
            double? timeEventHastaMDouble;
            double? timeEventDesdeTDouble;
            double? timeEventHastaTDouble;
            if (hoursEvents[k].horarios_eventos_desde_m != null &&
                hoursEvents[k].horarios_eventos_hasta_m != null &&
                hoursEvents[k].horarios_eventos_desde_t != null &&
                hoursEvents[k].horarios_eventos_hasta_t != null) {
              timeEventDesdeMDouble = timeDayEventDesdeM!.hour.toInt() +
                  timeDayEventDesdeM.minute / 60.0;
              timeEventHastaMDouble = timeDayEventHastaM!.hour.toInt() +
                  timeDayEventHastaM.minute / 60.0;

              timeEventDesdeTDouble = timeDayEventDesdeT!.hour.toInt() +
                  timeDayEventDesdeT.minute / 60.0;

              timeEventHastaTDouble = timeDayEventHastaT!.hour.toInt() +
                  timeDayEventHastaT.minute / 60.0;
            } else {
              if (hoursEvents[k].horarios_eventos_desde_m == null &&
                  hoursEvents[k].horarios_eventos_hasta_m == null &&
                  hoursEvents[k].horarios_eventos_desde_t != null &&
                  hoursEvents[k].horarios_eventos_hasta_t != null) {
                timeEventDesdeTDouble = timeDayEventDesdeT!.hour.toInt() +
                    timeDayEventDesdeT.minute / 60.0;

                timeEventHastaTDouble = timeDayEventHastaT!.hour.toInt() +
                    timeDayEventHastaT.minute / 60.0;
              }
              if (hoursEvents[k].horarios_eventos_desde_m != null &&
                  hoursEvents[k].horarios_eventos_hasta_m != null &&
                  hoursEvents[k].horarios_eventos_desde_t == null &&
                  hoursEvents[k].horarios_eventos_hasta_t == null) {
                timeEventDesdeMDouble = timeDayEventDesdeM!.hour.toInt() +
                    timeDayEventDesdeM.minute / 60.0;
                timeEventHastaMDouble = timeDayEventHastaM!.hour.toInt() +
                    timeDayEventHastaM.minute / 60.0;
              }
            }

            double timeNowDouble = dayNow.hour.toInt() + dayNow.minute / 60.0;
/*
            if (timeEventDouble < timeNowDouble) {
              print('cerrado');
            }*/
            // print('time event desde' + timeEventDesdeT.toString());
            // bool open = isOpen(timeEventDesdeMDouble, timeEventHastaMDouble,
            //     timeEventDesdeTDouble, timeEventHastaTDouble, timeNowDouble);
            // print('open now' + event.evento_nombre + open.toString());
            if (dayEvent == dateToday) {
              events.add(event);
            }
          }
        }
      }
    } else {
      print(resp.body.toString());
    }
    print('length event' + events.length.toString());
    return events;
  }

  //filtro de eventos
  Future<List<Event>> getEventsWithFilter(
    String categorySelected,
    bool isFree,
    String fechaDesde,
    String fechaHasta,
    String province,
    String nameEvent,
  ) async {
    List<Event> events = [];
    if (nameEvent.isNotEmpty) {
      nameEvent = nameEvent.toLowerCase();
    }
    String url = 'http://10.0.3.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      //final jsonData = json.decode(resp.body);
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));

      if (nameEvent.isEmpty && categorySelected != "Todas") {
        for (int i = 0; i <= jsonData.length - 1; i++) {
          Event event = Event.fromJSON(jsonData[i]);
          //Buscar eventos sin importar rango de fechas
          if (fechaDesde == 'dd/mm/yyyy' && fechaHasta == 'dd/mm/yyyy') {
            if (event.evento_esgratis == 1 &&
                isFree == true &&
                categorySelected == event.categoria_evento) {
              events.add(event);
            }
            if (event.evento_esgratis == 0 &&
                isFree == false &&
                categorySelected == event.categoria_evento) {
              events.add(event);
            }
          } else {
            //Buscar eventos considerando rango de fechas

            //Averiguar si es repetitivo
            if (event.evento_esrepetitivo == 1 &&
                isFree == true &&
                event.categoria_evento == categorySelected) {
              //Si es repetitivo, obtenemos los dias que se desarrolla el evento
              List<HourEvent> hoursEvents =
                  await DatesProvider().getDaysFromEvent(event.evento_id);
              //obtener dia de hoy
              const Map<int, String> weekdayName = {
                1: "Monday",
                2: "Tuesday",
                3: "Wednesday",
                4: "Thursday",
                5: "Friday",
                6: "Saturday",
                7: "Sunday"
              };

              String day = UtilitiesEvent()
                  .getDay(weekdayName[DateTime.now().weekday].toString());
              DateFormat format = DateFormat("yyyy-MM-dd");
              if (hoursEvents.isNotEmpty) {
                if (hoursEvents[0].horarios_eventos_fecha_desde == null &&
                    hoursEvents[0].horarios_eventos_fecha_hasta == null) {
                  events.add(event);
                  break;
                } else {
                  //en caso de que el evento repetitivo tenga un periodo, hacemos la comparacion
                  if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                      hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                      fechaDesde != 'dd/mm/yyyy' &&
                      fechaHasta != 'dd/mm/yyyy') {
                    DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                        .parse(Dates().invertDay(fechaDesde));
                    DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                        .parse(Dates().invertDay(fechaHasta));
                    DateTime dateEventFrom = format
                        .parse(hoursEvents[0].horarios_eventos_fecha_desde);
                    DateTime dateEventHasta = format
                        .parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                    if (dateTimeDesde.isAfter(dateEventFrom) &&
                        dateTimeHasta.isBefore(dateEventHasta)) {
                      events.add(event);
                    }

                    if (dateEventFrom.isBefore(dateTimeDesde) &&
                        dateEventHasta.isAfter(dateTimeHasta)) {
                      events.add(event);
                    } else {
                      print('fa3');
                    }
                  } else {
                    print('fecha desde' + fechaDesde);
                    print('fecha hasta' + fechaHasta);
                    print('horas evento' +
                        hoursEvents[0].horarios_eventos_fecha_desde.toString());
                    if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                        fechaDesde != 'dd/mm/yyyy' &&
                        fechaHasta == 'dd/mm/yyyy') {
                      DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaDesde));
                      print('134');
                      DateTime dateEventFrom = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_desde);

                      if (dateTimeDesde.isBefore(dateEventFrom) ||
                          dateTimeDesde.difference(dateEventFrom).inDays == 0) {
                        events.add(event);
                      } else {
                        print('fa1');
                      }
                    } else {
                      if (hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                          fechaDesde == 'dd/mm/yyyy' &&
                          fechaHasta != 'dd/mm/yyyy' &&
                          hoursEvents[0].horarios_eventos_fecha_desde != null) {
                        DateTime dateTimeTo = DateFormat('yyyy-MM-dd')
                            .parse(Dates().invertDay(fechaHasta));

                        DateTime dateEventTo = format
                            .parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                        print('date event to' + dateEventTo.toString());
                        if (dateTimeTo.isBefore(dateEventTo) ||
                            dateEventTo.difference(dateTimeTo).inDays == 0) {
                          print('qwe');
                          events.add(event);
                        } else {
                          print('fa2');
                        }
                      }
                    }
                  }
                }
              }
            } else {
              print('13433');
              if (event.evento_esrepetitivo == 0 &&
                  isFree == false &&
                  event.categoria_evento == categorySelected &&
                  fechaDesde != 'dd/mm/yyyy' &&
                  fechaHasta != 'dd/mm/yyyy') {
                List<DateEvent> dateEvents =
                    await DatesProvider().getDatesFromEvent(event.evento_id);

                DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaDesde));
                DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaHasta));
                bool include = false;
                for (int i = 0; i <= dateEvents.length - 1; i++) {
                  DateTime timeEvent =
                      DateTime.parse(dateEvents[i].fecha_evento_dia);
                  if (timeEvent.isAfter(dateTimeDesde) &&
                          timeEvent.isBefore(dateTimeHasta) ||
                      (timeEvent.difference(dateTimeDesde).inDays == 0 ||
                          timeEvent.difference(dateTimeHasta).inDays == 0)) {
                    include = true;
                  }
                }

                if (include == true) {
                  events.add(event);
                }
              }
              if (event.evento_esgratis == 1 &&
                  isFree == true &&
                  event.categoria_evento == categorySelected &&
                  event.evento_esrepetitivo == 0 &&
                  fechaDesde != 'dd/mm/yyyy' &&
                  fechaHasta != 'dd/mm/yyyy') {
                print('13499');
                List<DateEvent> dateEvents =
                    await DatesProvider().getDatesFromEvent(event.evento_id);
                DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaDesde));
                DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaHasta));
                bool include = false;
                for (int i = 0; i <= dateEvents.length - 1; i++) {
                  DateTime timeEvent =
                      DateTime.parse(dateEvents[i].fecha_evento_dia);
                  if (timeEvent.isAfter(dateTimeDesde) &&
                          timeEvent.isBefore(dateTimeHasta) ||
                      (timeEvent.difference(dateTimeDesde).inDays == 0 ||
                          timeEvent.difference(dateTimeHasta).inDays == 0)) {
                    include = true;
                  }
                }

                if (include == true) {
                  events.add(event);
                }
              }
              if (fechaDesde != 'dd/mm/yyyy' &&
                  event.evento_esrepetitivo == 0 &&
                  event.categoria_evento == categorySelected &&
                  isFree == false &&
                  event.evento_esgratis == 0) {
                List<DateEvent> dateEvents =
                    await DatesProvider().getDatesFromEvent(event.evento_id);
                DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaDesde));

                bool include = false;
                for (int i = 0; i <= dateEvents.length - 1; i++) {
                  DateTime timeEvent =
                      DateTime.parse(dateEvents[i].fecha_evento_dia);
                  if (timeEvent.isAfter(dateTimeDesde) ||
                      timeEvent.difference(dateTimeDesde).inDays == 0) {
                    include = true;
                  }
                }

                if (include == true) {
                  events.add(event);
                }
              }
              if (fechaHasta != 'dd/mm/yyyy' &&
                  event.evento_esrepetitivo == 0 &&
                  event.categoria_evento == categorySelected &&
                  isFree == false &&
                  event.evento_esgratis == 0) {
                print('ab');
                List<DateEvent> dateEvents =
                    await DatesProvider().getDatesFromEvent(event.evento_id);

                DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                    .parse(Dates().invertDay(fechaHasta));
                bool include = false;
                for (int i = 0; i <= dateEvents.length - 1; i++) {
                  DateTime timeEvent =
                      DateTime.parse(dateEvents[i].fecha_evento_dia);
                  if (timeEvent.isBefore(dateTimeHasta) ||
                      timeEvent.difference(dateTimeHasta).inDays == 0) {
                    include = true;
                  }
                }

                if (include == true) {
                  events.add(event);
                }
              }
            }
          }

          //Place place = await PlacesProvider().getPlace(event.evento_lugar);

        }
      } else {
        if (categorySelected == "Todas" && nameEvent.isEmpty) {
          for (int i = 0; i <= jsonData.length - 1; i++) {
            Event event = Event.fromJSON(jsonData[i]);
            //Buscar eventos sin importar rango de fechas
            print('event4' +
                event.evento_nombre +
                " " +
                event.evento_esrepetitivo.toString() +
                " " +
                event.evento_esgratis.toString());
            if (fechaDesde == 'dd/mm/yyyy' && fechaHasta == 'dd/mm/yyyy') {
              if (event.evento_esgratis == 1 &&
                  isFree == true &&
                  event.evento_esrepetitivo == 1) {
                print('evento name1' + event.evento_nombre);
                events.add(event);
              }
              if (event.evento_esgratis == 0 &&
                  isFree == false &&
                  event.evento_esrepetitivo == 0) {
                print('evento name2' + event.evento_nombre);
                events.add(event);
              }
              if (event.evento_esgratis == 1 &&
                  isFree == true &&
                  event.evento_esrepetitivo == 0) {
                print('evento name3' + event.evento_nombre);
                events.add(event);
              }
              if (event.evento_esgratis == 0 &&
                  isFree == false &&
                  event.evento_esrepetitivo == 1) {
                print('evento name4' + event.evento_nombre);
                events.add(event);
              }
            } else {
              //Buscar eventos considerando rango de fechas

              //Averiguar si es repetitivo
              if (event.evento_esrepetitivo == 1 && isFree == true) {
                //Si es repetitivo, obtenemos los dias que se desarrolla el evento
                List<HourEvent> hoursEvents =
                    await DatesProvider().getDaysFromEvent(event.evento_id);
                //obtener dia de hoy
                const Map<int, String> weekdayName = {
                  1: "Monday",
                  2: "Tuesday",
                  3: "Wednesday",
                  4: "Thursday",
                  5: "Friday",
                  6: "Saturday",
                  7: "Sunday"
                };

                String day = UtilitiesEvent()
                    .getDay(weekdayName[DateTime.now().weekday].toString());
                DateFormat format = DateFormat("yyyy-MM-dd");
                if (hoursEvents.isNotEmpty) {
                  if (hoursEvents[0].horarios_eventos_fecha_desde == null &&
                      hoursEvents[0].horarios_eventos_fecha_hasta == null) {
                    events.add(event);
                    break;
                  } else {
                    //en caso de que el evento repetitivo tenga un periodo, hacemos la comparacion
                    if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                        hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                        fechaDesde != 'dd/mm/yyyy' &&
                        fechaHasta != 'dd/mm/yyyy') {
                      print('134');
                      DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaDesde));
                      DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaHasta));
                      DateTime dateEventFrom = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_desde);
                      DateTime dateEventHasta = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                      if (dateTimeDesde.isAfter(dateEventFrom) &&
                              dateTimeHasta.isBefore(dateEventHasta) ||
                          (dateTimeDesde.difference(dateEventFrom).inDays ==
                                  0 ||
                              dateTimeHasta.difference(dateEventHasta).inDays ==
                                  0)) {
                        events.add(event);
                      }

                      if (dateEventFrom.isBefore(dateTimeDesde) &&
                          dateEventHasta.isAfter(dateTimeHasta)) {
                        events.add(event);
                      } else {
                        print('fa3');
                      }
                    } else {
                      print('fecha desde' + fechaDesde);
                      print('fecha hasta' + fechaHasta);
                      print('horas evento' +
                          hoursEvents[0]
                              .horarios_eventos_fecha_desde
                              .toString());
                      if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                          fechaDesde != 'dd/mm/yyyy' &&
                          fechaHasta == 'dd/mm/yyyy') {
                        DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                            .parse(Dates().invertDay(fechaDesde));
                        print('134');
                        DateTime dateEventFrom = format
                            .parse(hoursEvents[0].horarios_eventos_fecha_desde);

                        if (dateTimeDesde.isBefore(dateEventFrom) ||
                            dateTimeDesde.difference(dateEventFrom).inDays ==
                                0) {
                          events.add(event);
                        } else {
                          print('fa1');
                        }
                      } else {
                        if (hoursEvents[0].horarios_eventos_fecha_hasta !=
                                null &&
                            fechaDesde == 'dd/mm/yyyy' &&
                            fechaHasta != 'dd/mm/yyyy' &&
                            hoursEvents[0].horarios_eventos_fecha_desde !=
                                null) {
                          DateTime dateTimeTo = DateFormat('yyyy-MM-dd')
                              .parse(Dates().invertDay(fechaHasta));

                          DateTime dateEventTo = format.parse(
                              hoursEvents[0].horarios_eventos_fecha_hasta);
                          print('date event to' + dateEventTo.toString());
                          if (dateTimeTo.isBefore(dateEventTo)) {
                            print('qwe');
                            events.add(event);
                          } else {
                            print('fa2');
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                print('13433');
                if (event.evento_esrepetitivo == 0 &&
                    isFree == false &&
                    fechaDesde != 'dd/mm/yyyy' &&
                    fechaHasta != 'dd/mm/yyyy') {
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);

                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));
                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    print('fecha evento dia' +
                        " " +
                        i.toString() +
                        dateEvents[i].fecha_evento_dia);
                    print('date time desde' + dateTimeDesde.toString());
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    print('time event' + timeEvent.toString());
                    if (dateTimeDesde.difference(timeEvent).inDays <= 0 &&
                        dateTimeHasta.difference(timeEvent).inDays >= 0) {
                      print('juj');
                      include = true;
                    } else {
                      print('juj1' + timeEvent.toString());
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (event.evento_esgratis == 1 &&
                    isFree == true &&
                    event.evento_esrepetitivo == 0 &&
                    fechaDesde != 'dd/mm/yyyy' &&
                    fechaHasta != 'dd/mm/yyyy') {
                  print('13499');
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);
                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));
                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isAfter(dateTimeDesde) &&
                        timeEvent.isBefore(dateTimeHasta)) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (fechaDesde != 'dd/mm/yyyy' &&
                    event.evento_esrepetitivo == 0 &&
                    isFree == false &&
                    event.evento_esgratis == 0 &&
                    fechaHasta == 'dd/mm/yyyy') {
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);
                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));

                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isAfter(dateTimeDesde) ||
                        timeEvent.difference(dateTimeDesde).inDays == 0) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (fechaHasta != 'dd/mm/yyyy' &&
                    event.evento_esrepetitivo == 0 &&
                    isFree == false &&
                    event.evento_esgratis == 0 &&
                    fechaDesde == 'dd/mm/yyyy') {
                  print('ab');
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);

                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isBefore(dateTimeHasta) ||
                        timeEvent.difference(dateTimeHasta).inDays == 0) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
              }
            }

            //Place place = await PlacesProvider().getPlace(event.evento_lugar);

          }
        } else {
          print('todas y el nombre no es vacio');
          for (int i = 0; i <= jsonData.length - 1; i++) {
            Event event = Event.fromJSON(jsonData[i]);
            //Buscar eventos sin importar rango de fechas
            if (fechaDesde == 'dd/mm/yyyy' && fechaHasta == 'dd/mm/yyyy') {
              if (event.evento_esgratis == 1 &&
                      isFree == true &&
                      nameEvent.contains(event.evento_nombre.toLowerCase())
                  // event.evento_nombre.contains(nameEvent)
                  /*
                  &&
                  event.evento_nombre == nameEvent*/
                  ) {
                events.add(event);
              }
              if (event.evento_esgratis == 0 &&
                  isFree == false &&
                  nameEvent.contains(event.evento_nombre
                      .toLowerCase()) /*event.evento_nombre == nameEvent*/) {
                events.add(event);
              }
            } else {
              //Buscar eventos considerando rango de fechas

              //Averiguar si es repetitivo
              if (event.evento_esrepetitivo == 1 &&
                      isFree == true &&
                      nameEvent.contains(event.evento_nombre.toLowerCase())
                  /*
                  &&
                  event.evento_nombre == nameEvent*/
                  ) {
                //Si es repetitivo, obtenemos los dias que se desarrolla el evento
                List<HourEvent> hoursEvents =
                    await DatesProvider().getDaysFromEvent(event.evento_id);
                //obtener dia de hoy
                const Map<int, String> weekdayName = {
                  1: "Monday",
                  2: "Tuesday",
                  3: "Wednesday",
                  4: "Thursday",
                  5: "Friday",
                  6: "Saturday",
                  7: "Sunday"
                };

                String day = UtilitiesEvent()
                    .getDay(weekdayName[DateTime.now().weekday].toString());
                DateFormat format = DateFormat("yyyy-MM-dd");
                if (hoursEvents.isNotEmpty) {
                  if (hoursEvents[0].horarios_eventos_fecha_desde == null &&
                      hoursEvents[0].horarios_eventos_fecha_hasta == null) {
                    events.add(event);
                    break;
                  } else {
                    //en caso de que el evento repetitivo tenga un periodo, hacemos la comparacion
                    if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                        hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                        fechaDesde != 'dd/mm/yyyy' &&
                        fechaHasta != 'dd/mm/yyyy') {
                      print('134');
                      DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaDesde));
                      DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaHasta));
                      DateTime dateEventFrom = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_desde);
                      DateTime dateEventHasta = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                      if (dateTimeDesde.isAfter(dateEventFrom) &&
                          dateTimeHasta.isBefore(dateEventHasta)) {
                        events.add(event);
                      }

                      if (dateEventFrom.isBefore(dateTimeDesde) &&
                          dateEventHasta.isAfter(dateTimeHasta)) {
                        events.add(event);
                      } else {
                        print('fa3');
                      }
                    } else {
                      print('fecha desde' + fechaDesde);
                      print('fecha hasta' + fechaHasta);
                      print('horas evento' +
                          hoursEvents[0]
                              .horarios_eventos_fecha_desde
                              .toString());
                      if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                          fechaDesde != 'dd/mm/yyyy' &&
                          fechaHasta == 'dd/mm/yyyy') {
                        DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                            .parse(Dates().invertDay(fechaDesde));
                        print('134');
                        DateTime dateEventFrom = format
                            .parse(hoursEvents[0].horarios_eventos_fecha_desde);

                        if (dateTimeDesde.isBefore(dateEventFrom)) {
                          events.add(event);
                        } else {
                          print('fa1');
                        }
                      } else {
                        if (hoursEvents[0].horarios_eventos_fecha_hasta !=
                                null &&
                            fechaDesde == 'dd/mm/yyyy' &&
                            fechaHasta != 'dd/mm/yyyy' &&
                            hoursEvents[0].horarios_eventos_fecha_desde !=
                                null) {
                          DateTime dateTimeTo = DateFormat('yyyy-MM-dd')
                              .parse(Dates().invertDay(fechaHasta));

                          DateTime dateEventTo = format.parse(
                              hoursEvents[0].horarios_eventos_fecha_hasta);
                          print('date event to' + dateEventTo.toString());
                          if (dateTimeTo.isBefore(dateEventTo)) {
                            print('qwe');
                            events.add(event);
                          } else {
                            print('fa2');
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                print('13433');
                if (event.evento_esrepetitivo == 0 &&
                    isFree == false &&
                    nameEvent.contains(event.evento_nombre.toLowerCase()) &&
                    //event.evento_nombre == nameEvent &&
                    fechaDesde != 'dd/mm/yyyy' &&
                    fechaHasta != 'dd/mm/yyyy') {
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);

                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));
                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isAfter(dateTimeDesde) &&
                        timeEvent.isBefore(dateTimeHasta)) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (event.evento_esgratis == 1 &&
                    isFree == true &&
                    event.evento_esrepetitivo == 0 &&
                    nameEvent.contains(event.evento_nombre.toLowerCase()) &&
                    //event.evento_nombre == nameEvent &&
                    fechaDesde != 'dd/mm/yyyy' &&
                    fechaHasta != 'dd/mm/yyyy') {
                  print('13499');
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);
                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));
                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isAfter(dateTimeDesde) &&
                        timeEvent.isBefore(dateTimeHasta)) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (fechaDesde != 'dd/mm/yyyy' &&
                    event.evento_esrepetitivo == 0 &&
                    nameEvent.contains(event.evento_nombre.toLowerCase()) &&
                    // event.evento_nombre == nameEvent &&
                    isFree == false &&
                    event.evento_esgratis == 0) {
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);
                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));

                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isAfter(dateTimeDesde)) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
                if (fechaHasta != 'dd/mm/yyyy' &&
                    event.evento_esrepetitivo == 0 &&
                    nameEvent.contains(event.evento_nombre.toLowerCase()) &&
                    // event.evento_nombre == nameEvent &&
                    isFree == false &&
                    event.evento_esgratis == 0) {
                  print('ab');
                  List<DateEvent> dateEvents =
                      await DatesProvider().getDatesFromEvent(event.evento_id);

                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  bool include = false;
                  for (int i = 0; i <= dateEvents.length - 1; i++) {
                    DateTime timeEvent =
                        DateTime.parse(dateEvents[i].fecha_evento_dia);
                    if (timeEvent.isBefore(dateTimeHasta)) {
                      include = true;
                    }
                  }

                  if (include == true) {
                    events.add(event);
                  }
                }
              }
            }

            //Place place = await PlacesProvider().getPlace(event.evento_lugar);

          }
        }
      }
    }
    return events;
  }
  /*
  Future<List<Event>> getEventsWithFilter(String categorySelected, bool isFree,
      String fechaDesde, String fechaHasta, String nameEvent) async {
    List<Event> events = [];

    String url = 'http://10.0.2.2:8000/api/eventos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      //final jsonData = json.decode(resp.body);
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));

      for (int i = 0; i <= jsonData.length - 1; i++) {
        Event event = Event.fromJSON(jsonData[i]);
        //Buscar eventos sin importar rango de fechas
        if (fechaDesde == 'dd/mm/yyyy' && fechaHasta == 'dd/mm/yyyy') {
          if (event.evento_esgratis == 1 &&
              isFree == true &&
              categorySelected == event.categoria_evento) {
            events.add(event);
          }
          if (event.evento_esgratis == 0 &&
              isFree == false &&
              categorySelected == event.categoria_evento) {
            events.add(event);
          }
        } else {
          //Buscar eventos considerando rango de fechas

          //Averiguar si es repetitivo
          if (event.evento_esrepetitivo == 1 &&
              isFree == true &&
              event.categoria_evento == categorySelected) {
            //Si es repetitivo, obtenemos los dias que se desarrolla el evento
            List<HourEvent> hoursEvents =
                await DatesProvider().getDaysFromEvent(event.evento_id);
            //obtener dia de hoy
            const Map<int, String> weekdayName = {
              1: "Monday",
              2: "Tuesday",
              3: "Wednesday",
              4: "Thursday",
              5: "Friday",
              6: "Saturday",
              7: "Sunday"
            };
//print(weekdayName[DateTime.now().weekday]);
//obtenemos el dia de hoy
            String day = UtilitiesEvent()
                .getDay(weekdayName[DateTime.now().weekday].toString());
            DateFormat format = DateFormat("yyyy-MM-dd");
            if (hoursEvents.isNotEmpty) {
              if (hoursEvents[0].horarios_eventos_fecha_desde == null &&
                  hoursEvents[0].horarios_eventos_fecha_hasta == null) {
                events.add(event);
                break;
              } else {
                //en caso de que el evento repetitivo tenga un periodo, hacemos la comparacion
                if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                    hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                    fechaDesde != 'dd/mm/yyyy' &&
                    fechaHasta != 'dd/mm/yyyy') {
                  print('134');
                  DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaDesde));
                  DateTime dateTimeHasta = DateFormat('yyyy-MM-dd')
                      .parse(Dates().invertDay(fechaHasta));
                  DateTime dateEventFrom =
                      format.parse(hoursEvents[0].horarios_eventos_fecha_desde);
                  DateTime dateEventHasta =
                      format.parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                  if (dateTimeDesde.isAfter(dateEventFrom) &&
                      dateTimeHasta.isBefore(dateEventHasta)) {
                    events.add(event);
                  }

                  if (dateEventFrom.isBefore(dateTimeDesde) &&
                      dateEventHasta.isAfter(dateTimeHasta)) {
                    events.add(event);
                  } else {
                    print('fa3');
                  }
                } else {
                  print('fecha desde' + fechaDesde);
                  print('fecha hasta' + fechaHasta);
                  print('horas evento' +
                      hoursEvents[0].horarios_eventos_fecha_desde.toString());
                  if (hoursEvents[0].horarios_eventos_fecha_desde != null &&
                      fechaDesde != 'dd/mm/yyyy' &&
                      fechaHasta == 'dd/mm/yyyy') {
                    DateTime dateTimeDesde = DateFormat('yyyy-MM-dd')
                        .parse(Dates().invertDay(fechaDesde));
                    print('134');
                    DateTime dateEventFrom = format
                        .parse(hoursEvents[0].horarios_eventos_fecha_desde);

                    if (dateTimeDesde.isBefore(dateEventFrom)) {
                      events.add(event);
                    } else {
                      print('fa1');
                    }
                  } else {
                    if (hoursEvents[0].horarios_eventos_fecha_hasta != null &&
                        fechaDesde == 'dd/mm/yyyy' &&
                        fechaHasta != 'dd/mm/yyyy' &&
                        hoursEvents[0].horarios_eventos_fecha_desde != null) {
                      DateTime dateTimeTo = DateFormat('yyyy-MM-dd')
                          .parse(Dates().invertDay(fechaHasta));

                      DateTime dateEventTo = format
                          .parse(hoursEvents[0].horarios_eventos_fecha_hasta);
                      print('date event to' + dateEventTo.toString());
                      if (dateTimeTo.isBefore(dateEventTo)) {
                        print('qwe');
                        events.add(event);
                      } else {
                        print('fa2');
                      }
                    }
                  }
                }
              }
            }
          } else {
            print('13433');
            if (event.evento_esrepetitivo == 0 &&
                isFree == false &&
                event.categoria_evento == categorySelected &&
                fechaDesde != 'dd/mm/yyyy' &&
                fechaHasta != 'dd/mm/yyyy') {
              List<DateEvent> dateEvents =
                  await DatesProvider().getDatesFromEvent(event.evento_id);

              DateTime dateTimeDesde =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaDesde));
              DateTime dateTimeHasta =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaHasta));
              bool include = false;
              for (int i = 0; i <= dateEvents.length - 1; i++) {
                DateTime timeEvent =
                    DateTime.parse(dateEvents[i].fecha_evento_dia);
                if (timeEvent.isAfter(dateTimeDesde) &&
                    timeEvent.isBefore(dateTimeHasta)) {
                  include = true;
                }
              }

              if (include == true) {
                events.add(event);
              }
            }
            if (event.evento_esgratis == 1 &&
                isFree == true &&
                event.categoria_evento == categorySelected &&
                event.evento_esrepetitivo == 0 &&
                fechaDesde != 'dd/mm/yyyy' &&
                fechaHasta != 'dd/mm/yyyy') {
              print('13499');
              List<DateEvent> dateEvents =
                  await DatesProvider().getDatesFromEvent(event.evento_id);
              DateTime dateTimeDesde =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaDesde));
              DateTime dateTimeHasta =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaHasta));
              bool include = false;
              for (int i = 0; i <= dateEvents.length - 1; i++) {
                DateTime timeEvent =
                    DateTime.parse(dateEvents[i].fecha_evento_dia);
                if (timeEvent.isAfter(dateTimeDesde) &&
                    timeEvent.isBefore(dateTimeHasta)) {
                  include = true;
                }
              }

              if (include == true) {
                events.add(event);
              }
            }
            if (fechaDesde != 'dd/mm/yyyy' &&
                event.evento_esrepetitivo == 0 &&
                event.categoria_evento == categorySelected &&
                isFree == false &&
                event.evento_esgratis == 0) {
              List<DateEvent> dateEvents =
                  await DatesProvider().getDatesFromEvent(event.evento_id);
              DateTime dateTimeDesde =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaDesde));

              bool include = false;
              for (int i = 0; i <= dateEvents.length - 1; i++) {
                DateTime timeEvent =
                    DateTime.parse(dateEvents[i].fecha_evento_dia);
                if (timeEvent.isAfter(dateTimeDesde)) {
                  include = true;
                }
              }

              if (include == true) {
                events.add(event);
              }
            }
            if (fechaHasta != 'dd/mm/yyyy' &&
                event.evento_esrepetitivo == 0 &&
                event.categoria_evento == categorySelected &&
                isFree == false &&
                event.evento_esgratis == 0) {
              print('ab');
              List<DateEvent> dateEvents =
                  await DatesProvider().getDatesFromEvent(event.evento_id);

              DateTime dateTimeHasta =
                  DateFormat('yyyy-MM-dd').parse(Dates().invertDay(fechaHasta));
              bool include = false;
              for (int i = 0; i <= dateEvents.length - 1; i++) {
                DateTime timeEvent =
                    DateTime.parse(dateEvents[i].fecha_evento_dia);
                if (timeEvent.isBefore(dateTimeHasta)) {
                  include = true;
                }
              }

              if (include == true) {
                events.add(event);
              }
            }
          }
        }

        //Place place = await PlacesProvider().getPlace(event.evento_lugar);

      }
    }
    return events;
  }*/
/*
  bool isOpen(double? horarioDesdeM, double? horarioHastaM,
      double? horarioDesdeT, double? horarioHastaT, double horario_actual) {
    bool isOpen = false;

    //Apertura maniana y tarde
    if (horario_actual > horarioDesdeM! && horario_actual < horarioHastaM! ||
        horario_actual > horarioDesdeT! && horario_actual < horarioHastaT!) {
      isOpen = true;
    } else {
      //apertura solo maniana
      if (horario_actual > horarioDesdeM &&
          horario_actual < horarioHastaM! &&
          horarioDesdeT == null &&
          horarioHastaT == null) {
        isOpen = true;
      }
      //apertura solo tarde
      if (horario_actual > horarioDesdeT &&
          horario_actual < horarioHastaT! &&
          horarioDesdeM == null &&
          horarioHastaM == null) {
        isOpen = true;
      }
    }
    return isOpen;
  }*/
}
