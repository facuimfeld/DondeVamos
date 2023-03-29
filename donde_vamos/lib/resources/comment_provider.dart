import 'dart:convert';

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/comment_place.dart';
import 'package:http/http.dart' as http;

class CommentProvider {
  //borrar comentario de un evento
  Future<void> deleteCommentEvent(int idEvent) async {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );
    String username = await LocalPreferences().getUsername();
    String idPE = "0";
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["comentario_evento_evento_id"] == idEvent &&
            jsonData[i]["comentario_evento_usuario"] == username) {
          idPE = jsonData[i]["comentario_evento_id"].toString();
        }
      }
      String url2 = 'http://10.0.3.2:8000/api/comentario-evento/$idPE/';
      var resp2 = await http.delete(
        Uri.parse(url2),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (resp2.statusCode == 204) {
        print('comentario de evento borrado!');
      } else {
        print('err' + resp2.body.toString());
      }
    }
  }

  //Obtiene el id primario del comentario dado un username y id de lugar
  Future<int> getIDPrimary(String username, int idPlace) async {
    int id = 0;
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["comentario_lugar_lugar_id"] == idPlace &&
            username == jsonData[i]["comentario_lugar_usuario"]) {
          id = jsonData[i]["comentario_lugar_id"];
        }
      }
    }
    return id;
  }

  //Edita comentario de un lugar
  Future<void> updateComment(Map<String, dynamic> place) async {
    String username = await LocalPreferences().getUsername();
    int idKey =
        await getIDPrimary(username, place["comentario_lugar_lugar_id"]);
    String keyString = idKey.toString();
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/$keyString/';
    var resp = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(place));
    if (resp.statusCode == 200) {
      print('atualizado!!!');
    }
  }

  //Obtiene los comentarios de un lugar
  Future<List<CommentPlace>> getAllCommentsPlace(int idPlace) async {
    print('id lug' + idPlace.toString());
    List<CommentPlace> commentPlaces = [];
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';

    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        CommentPlace commentPlace = CommentPlace.fromJSON(jsonData[i]);
        if (commentPlace.lugar == idPlace) {
          commentPlaces.add(commentPlace);
        }
      }
    } else {
      print('err' + resp.body.toString());
    }
    return commentPlaces;
  }

  //obtener cantidad de comentarios de un lugar
  Future<int> getCommentsPlace(int idPlace) async {
    print('ID LUGAR' + idPlace.toString());
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';
    int cantcomments = 0;
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["comentario_lugar_lugar_id"] == idPlace) {
          cantcomments++;
        }
      }
    }

    return cantcomments;
  }

  //obtener cantidad de comentarios
  Future<int> getComments(int idE) async {
    String url = 'http://10.0.3.2:8000/api/comentario-evento/';
    int cantcomments = 0;
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["comentario_evento_evento_id"] == idE) {
          cantcomments++;
        }
      }
    }

    return cantcomments;
  }

  //borrar comentario de un lugar
  Future<void> deleteCommentPlace(int idPlace) async {
    String url = 'http://10.0.3.2:8000/api/comentario-lugar/';
    String loggedUsername = await LocalPreferences().getUsername();
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    int idP = 0;
    if (resp.statusCode == 200) {
      final jsonData = json.decode(resp.body);
      for (int i = 0; i <= jsonData.length - 1; i++) {
        print('jsond' + jsonData[i].toString());
        if (jsonData[i]["comentario_lugar_lugar_id"] == idPlace &&
            loggedUsername == jsonData[i]["comentario_lugar_usuario"]) {
          idP = jsonData[i]["comentario_lugar_id"];
        }
        String stringP = idP.toString();
        print('string p' + stringP);
        String url2 = 'http://10.0.3.2:8000/api/comentario-lugar/$stringP/';
        var resp2 = await http.delete(Uri.parse(url2), headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        });
        if (resp2.statusCode == 204) {
          print('comentario de lugar borrado!');
        } else {
          print('err' + resp.body.toString());
        }
      }
    }
  }
}
