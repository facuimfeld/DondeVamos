import 'dart:convert';

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/calification_place.dart';
import 'package:donde_vamos/models/comment.dart';
import 'package:donde_vamos/models/suscription_event.dart';
import 'package:donde_vamos/models/suscription_place.dart';
import 'package:donde_vamos/ui/suscriptions/suscriptions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SuscriptionProvider {
  //borrar suscripcion a un lugar
  Future<void> deleteSuscriptionPlace(int idPlace, String username) async {
    String url = 'http://10.0.3.2:8000/api/suscribe-lugar/';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    int idPlacePrimary = 0;

    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["lugar"] == idPlace) {
          idPlacePrimary = jsonData[i]["suscribe_lugar_id"];
          print('id evento primary' + idPlacePrimary.toString());
          String idP = idPlacePrimary.toString();
          String url = 'http://10.0.3.2:8000/api/suscribe-lugar/$idP/';
          var resp2 = await http.delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
          );
          if (resp2.statusCode == 204) {
            print('suscripcion a lugar borrada');
          } else {
            print('code' + resp.statusCode.toString());
            print('err' + resp.body.toString());
          }
        }
      }
    } else {
      print('resp4' + resp.body.toString());
    }
  }

  //registrar suscripcion a un lugar
  Future<void> registerSuscriptionPlace(int idPlace, String username) async {
    Map<String, dynamic> data = {};
    String userid = await LocalPreferences().getUsername();
    data["lugar"] = idPlace;
    data["usuario"] = userid;
    String url = 'http://10.0.3.2:8000/api/suscribe-lugar/';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(data));

    if (resp.statusCode == 200) {
      print('suscripcion a un lugar realizada!');
    } else {
      print(resp.body.toString());
    }
  }

  //buscar id de comentario por id de evento

  Future<int> searchIDCommentByUsernameAndIDEvent(int idEvento) async {
    String username = await LocalPreferences().getUsername();
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    int idPrimaryComment = 0;
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        print(jsonData[i].toString());
        if (jsonData[i]["comentario_evento_usuario"] == username &&
            jsonData[i]["comentario_evento_evento_id"] == idEvento) {
          idPrimaryComment = jsonData[i]["comentario_evento_id"];
        }
      }
    }
    return idPrimaryComment;
  }

  //actualizar calificacion
  Future<void> updateCalification(Map<String, dynamic> data) async {
    int idComentario = await searchIDCommentByUsernameAndIDEvent(
        data["comentario_evento_evento_id"]);

    String url = 'http://10.0.3.2:8000/api/comentario-evento/$idComentario/';
    var resp = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(data));
    if (resp.statusCode == 200) {
      print('comentario actualizado!');
    } else {
      print('err' + resp.body.toString());
    }
  }

  //obtener suscripciones de eventos de un usuario
  Future<List<SuscriptionEvent>> getSuscriptions() async {
    String url = 'http://10.0.3.2:8000/api/suscribe-evento/';
    List<SuscriptionEvent> suscriptionsEvent = [];
    String username = await LocalPreferences().getUsername();
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["suscribe_evento_usuario"] == username) {
          SuscriptionEvent suscriptionEvent =
              SuscriptionEvent.fromJSON(jsonData[i]);
          suscriptionsEvent.add(suscriptionEvent);
        }
      }
    }

    return suscriptionsEvent;
  }

  //Registrar suscripcion a un evento
  Future<void> registerSuscription(int idEvento, String username) async {
    Map<String, dynamic> data = {};
    String userid = await LocalPreferences().getUsername();
    data["suscribe_evento_evento_id"] = idEvento;
    data["suscribe_evento_usuario"] = userid;
    String url = 'http://10.0.3.2:8000/api/suscribe-evento/';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data));

    if (resp.statusCode == 200) {
      print('suscripcion realizada!');
    } else {
      print(resp.body.toString());
    }
  }

  //Borrar suscripcion a un evento
  Future<void> deleteSuscription(int idEvento) async {
    String url = 'http://10.0.3.2:8000/api/suscribe-evento/';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    int idEventoPrimary = 0;

    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["suscribe_evento_evento_id"] == idEvento) {
          idEventoPrimary = jsonData[i]["suscribe_evento_id"];
          print('id evento primary' + idEventoPrimary.toString());
          String idEv = idEventoPrimary.toString();
          String url = 'http://10.0.3.2:8000/api/suscribe-evento/$idEv/';
          var resp = await http.delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
            },
          );
          if (resp.statusCode == 204) {
            print('suscrip borrada');
          } else {
            print('code' + resp.statusCode.toString());
            print('err' + resp.body.toString());
          }
        }
      }
    } else {
      print(resp.body.toString());
    }
  }

  //verificar si la suscripcion al lugar existe
  Future<bool> verifySuscriptionPlace(int idPlace) async {
    bool suscribe = false;
    String url = 'http://10.0.3.2:8000/api/suscribe-lugar/';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      if (jsonData.isNotEmpty) {
        for (int i = 0; i <= jsonData.length - 1; i++) {
          print('ASD' + jsonData[i].toString());
          if (jsonData[i]["lugar"] == idPlace) {
            suscribe = true;
          }
        }
      }
    } else {
      print(resp.body.toString());
    }

    return suscribe;
  }

  //verificar si la suscripcion al evento existe
  Future<bool> verifySuscription(int idEvento) async {
    bool suscribe = false;
    String url = 'http://10.0.3.2:8000/api/suscribe-evento/';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));

      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["suscribe_evento_evento_id"] == idEvento) {
          suscribe = true;
        }
      }
    } else {
      print(resp.body.toString());
    }

    return suscribe;
  }

//obtener comentarios de un evento dado un id
  Future<List<Comment>> getCommentsFromEvent(String idEvento) async {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    List<Comment> comments = [];
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Comment comment = Comment.fromJSON(jsonData[i]);
        if (comment.comentario_evento_evento_id == int.parse(idEvento)) {
          comments.add(comment);
        }
      }
    }

    return comments;
  }

  Stream<List<Comment>> getComments(String id) async* {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    List<Comment> comments = [];
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Comment comment = Comment.fromJSON(jsonData[i]);
        if (comment.comentario_evento_evento_id == int.parse(id)) {
          comments.add(comment);
        }
      }
    }

    yield comments;
  }

  //agregar calificacion a un lugar
  Future<void> sendCalificationPlace(Map<String, dynamic> data) async {
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(data));
    if (resp.statusCode == 200) {
      print('calif de lugar enviada');
    } else {
      print('err' + resp.body.toString());
    }
  }

//calificacion a un evento
  Future<void> sendCalification(Map<String, dynamic> data) async {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(data));
    if (resp.statusCode == 200) {
      print('calif enviada');
    } else {
      print('err' + resp.body.toString());
    }
  }

  //obtener calificacion de un evento
  Future<double> getScoreEvent(String idEvento) async {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    List<Comment> comments = [];
    int acumEvento = 0;
    double califEvento = 0;
    int totalCalif = 0;
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        Comment comment = Comment.fromJSON(jsonData[i]);
        if (comment.comentario_evento_evento_id == int.parse(idEvento)) {
          totalCalif++;
          acumEvento = acumEvento + comment.comentario_evento_calificacion;
        }
      }
    }
    if (totalCalif > 0) {
      califEvento = acumEvento / totalCalif;
    } else {
      califEvento = 0;
    }

    return califEvento;
  }

  //Obtener calificacion de un lugar
  Future<double> getScorePlace(String idPlace) async {
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';

    int acumPlace = 0;
    double calificacionPlace = 0;
    int totalCalif = 0;
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        CalificationPlace califPlace = CalificationPlace.fromJSON(jsonData[i]);
        if (califPlace.lugar == int.parse(idPlace)) {
          totalCalif++;
          acumPlace = acumPlace + califPlace.comentario_lugar_calificacion;
        }
      }
    }
    if (totalCalif > 0) {
      calificacionPlace = acumPlace / totalCalif;
    } else {
      calificacionPlace = 0;
    }

    return calificacionPlace;
  }

  //obtener suscripciones a un lugar
  Future<List<SuscriptionPlace>> getSuscriptionsPlaces() async {
    String url = 'http://10.0.3.2:8000/api/suscribe-lugar/';
    List<SuscriptionPlace> suscriptionsPlaces = [];
    String username = await LocalPreferences().getUsername();
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["usuario"] == username) {
          SuscriptionPlace suscriptionPlace =
              SuscriptionPlace.fromJSON(jsonData[i]);
          suscriptionsPlaces.add(suscriptionPlace);
        }
      }
    }

    return suscriptionsPlaces;
  }
}
