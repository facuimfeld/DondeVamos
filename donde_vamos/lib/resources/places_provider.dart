import 'dart:convert';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:donde_vamos/models/hour_place.dart';
import 'package:donde_vamos/models/type_place_gastronomic.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:donde_vamos/models/place.dart';
import 'package:intl/intl.dart';

class PlacesProvider {
  Future<int> getIDGastronomicPlace(String place) async {
    String url = 'http://10.0.3.2:8000/api/tipos-gastronomicos/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    int idGastronomic = 0;
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (place == jsonData[i]["tipo_gastronomico_descripcion"]) {
          idGastronomic = jsonData[i]["tipo_gastronomico_id"];
        }
      }
    }
    return idGastronomic;
  }

  //obtener horarios de lugares
  Future<List<HourPlace>> getHourFromPlace(int idLugar) async {
    List<HourPlace> hourPlaces = [];
    String url = 'http://10.0.3.2:8000/api/horarios-lugar/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        HourPlace hourPlace = HourPlace.fromJSON(jsonData[i]);
        if (hourPlace.horarios_lugar_id_lugar == idLugar) {
          hourPlaces.add(hourPlace);
        }
      }
    }
    return Future.value(hourPlaces);
  }

  Future<bool> isOpen(Place place) async {
    bool isOpen = false;
    //obtener horarios del lugar
    String nameCurrentDay = DateFormat('EEEE').format(DateTime.now());
    String charDay = Dates().getCharDay(nameCurrentDay);
    String url = 'http://10.0.3.2:8000/api/horarios-lugar/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        HourPlace hourPlace = HourPlace.fromJSON(jsonData[i]);
        print('hour place' + hourPlace.horarios_lugar_desde_m.toString());
        if (charDay == hourPlace.horarios_lugar_diadesem) {
          print('hour place' + hourPlace.horarios_lugar_desde_m.toString());
          if (hourPlace.horarios_lugar_desde_m ==
                  hourPlace.horarios_lugar_hasta_m &&
              hourPlace.horarios_lugar_desde_t ==
                  hourPlace.horarios_lugar_hasta_t) {
            isOpen = true;
          }
        }
      }
    }
    return isOpen;
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    DateTime timePlace = DateTime.parse(tod); //"6:00 AM"
    return TimeOfDay.fromDateTime(timePlace);
  }

  Future<Place> getPlace(int idPlace) async {
    String url = 'http://10.0.3.2:8000/api/lugares/$idPlace';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    Place place = Place(
        lugar_nombre: '',
        lugar_calle: '',
        lugar_numero: 0,
        tipo_lugar: '0',
        localidad_provincia: '',
        localidad_nombre: '',
        lugar_usuario: '',
        lugar_email: '',
        lugar_desc_corta: '',
        lugar_desc_larga: '',
        lugar_tipo_gastronomico: '',
        lugar_calificacion: '0.0',
        lugar_link: '',
        lugar_coordenadas: '',
        lugar_telefono: '',
        lugar_tipo_lugar: 0,
        lugar_localidad: 0);
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      place = Place.fromJSON(jsonData);
      print('nom lugar' + place.lugar_nombre.toString());
    }
    return place;
  }

  Future<String> getTypePlace(int typePlace) async {
    String url = 'http://10.0.3.2:8000/api/tipos-lugares';
    String tipolugar = '';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["tipo_lugar_id"] == typePlace) {
          tipolugar = jsonData[i]["tipo_lugar_descripcion"];
        }
      }
    }

    return tipolugar;
  }

  Future<List<String>> getTypePlaces() async {
    String url = 'http://10.0.3.2:8000/api/tipos-lugares';

    List<String> typePlaces = [];
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        typePlaces.add(jsonData[i]["tipo_lugar_descripcion"]);
      }
    }

    print(typePlaces.toString());

    return typePlaces;
  }

  Future<List<String>> getPlaces() async {
    String url = 'http://10.0.3.2:8000/api/tipos-lugares';

    List<String> typePlaces = [];
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        typePlaces.add(jsonData[i]["tipo_lugar_descripcion"]);
      }
    }

    print(typePlaces.toString());

    return typePlaces;
  }

  Future<List<Place>> getPlacesFilter(String selectedTypePlace, bool allPlaces,
      String gastronomicPlace, String namePlace) async {
    String url = 'http://10.0.3.2:8000/api/lugares';
    print('gastronomic place' + gastronomicPlace);
    List<Place> places = [];
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      if (namePlace.isEmpty) {
        for (int i = 0; i <= jsonData.length - 1; i++) {
          Place place = Place.fromJSON(jsonData[i]);

          if (place.tipo_lugar == selectedTypePlace) {
            if (place.lugar_tipo_gastronomico != null) {
              print('aaaa');
              /*
              List<TypePlaceGastronomic> listTypeGastronomicPlaces =
                  await getGastronomicPlaces();
              for (int i = 0; i <= listTypeGastronomicPlaces.length - 1; i++) {
                print(listTypeGastronomicPlaces[i]
                        .tipo_gastronomico_id
                        .toString() +
                    "  " +
                    listTypeGastronomicPlaces[i].tipo_gastronomico_descripcion);
                print('places' +
                    place.lugar_nombre! +
                    place.lugar_tipo_gastronomico.toString());
                if (listTypeGastronomicPlaces[i].tipo_gastronomico_id ==
                    int.parse(place.lugar_tipo_gastronomico.toString())) {
                  places.add(place);
                }
              }*/
              int idGastronomicPlaceSelected =
                  await getIDGastronomicPlace(gastronomicPlace);
              int idActualPlace =
                  int.parse(place.lugar_tipo_gastronomico.toString());
              if (idActualPlace == idGastronomicPlaceSelected) {
                places.add(place);
              }
            } else {
              places.add(place);
            }
          } else {
            if (selectedTypePlace == "Todos") {
              places.add(place);
            }
          }
        }
      } else {
        print('99');
        for (int i = 0; i <= jsonData.length - 1; i++) {
          Place place = Place.fromJSON(jsonData[i]);

          if (place.tipo_lugar == selectedTypePlace ||
              selectedTypePlace == "Todos") {
            if (place.lugar_tipo_gastronomico != null &&
                namePlace == place.lugar_nombre) {
              List<TypePlaceGastronomic> listTypeGastronomicPlaces =
                  await getGastronomicPlaces();
              for (int i = 0; i <= listTypeGastronomicPlaces.length - 1; i++) {
                if (listTypeGastronomicPlaces[i].tipo_gastronomico_id ==
                        place.lugar_tipo_gastronomico &&
                    namePlace == place.lugar_nombre) {
                  places.add(place);
                }
              }
            } else {
              if (namePlace == place.lugar_nombre) {
                places.add(place);
              }
            }
          } else {
            if (selectedTypePlace == "Todos" &&
                namePlace == place.lugar_nombre) {
              places.add(place);
            }
          }
        }
      }
    }

    //ordenar lista

    places.sort((a, b) {
      return a.lugar_nombre
          .toString()
          .toLowerCase()
          .compareTo(b.lugar_nombre.toString().toLowerCase());
    });
    return places;
  }

  Future<List<TypePlaceGastronomic>> getGastronomicPlaces() async {
    String url = 'http://10.0.3.2:8000/api/tipos-gastronomicos/';
    List<TypePlaceGastronomic> typesPlacesGastronomic = [];
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        TypePlaceGastronomic typeGastronomic =
            TypePlaceGastronomic.fromJSON(jsonData[i]);
        typesPlacesGastronomic.add(typeGastronomic);
      }
    }
    return typesPlacesGastronomic;
  }
}
