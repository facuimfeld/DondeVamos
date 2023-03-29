import 'dart:convert';

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  //editar datos de usuario
  Future<void> editDataUser(Map<String, dynamic> dataUser) async {
    String username = await LocalPreferences().getUsername();

    String url = 'http://10.0.3.2:8000/api/usuarios/$username/';
    var resp = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode(dataUser),
    );
    if (resp.statusCode == 200) {
      print('actualizdaos los datos');
    }
  }

  //obtener todos los datos del usuario dado su user id
  Future<User> getUser(String username) async {
    String url = 'http://10.0.3.2:8000/api/usuarios/$username/';

    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    User user = User(
        empresa_cuil: 0,
        usuario_apellido: '',
        usuario_contrasenia: '',
        usuario_email: '',
        usuario_id: '',
        usuario_nombre: '',
        usuario_tipo: '');
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      user = User.fromJSON(jsonData);
    }
    return user;
  }

  //obtener usuario a partir de un email
  Future<User> getUserFromEmail(String email) async {
    String url = 'http://10.0.3.2:8000/api/usuarios/';

    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    });
    User user = User(
        empresa_cuil: 0,
        usuario_apellido: '',
        usuario_contrasenia: '',
        usuario_email: '',
        usuario_id: '',
        usuario_nombre: '',
        usuario_tipo: '');
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["usuario_email"] == email) {
          user = User.fromJSON(jsonData[i]);
        }
      }
    }
    return user;
  }

  //registrar usuario
  Future<void> registerUser(User user) async {
    Map<String, dynamic> data = {};
    data = user.toMap();
    String url = 'http://10.0.3.2:8000/api/usuarios/';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));

    if (resp.statusCode == 200) {
      print('usuario registrado!');
    } else {
      print(resp.body.toString());
    }
  }

  Future<bool> verifyUser(String userid, String password) async {
    String url = 'http://10.0.3.2:8000/api/usuarios/';
    print('user id' + userid);
    print('password' + password);
    bool existsUser = false;
    var resp = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));

      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["usuario_contraseña"] == password &&
            jsonData[i]["usuario_email"] == userid) {
          existsUser = true;
        }
      }
    } else {
      print(resp.body.toString());
    }
    return existsUser;
  }

  Future<String> getNameAndSurnameUser(String userid) async {
    String url = 'http://10.0.3.2:8000/api/usuarios/';
    String nameUser = '';
    var resp = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (resp.statusCode == 200) {
      final jsonData = json.decode(utf8.decode(resp.bodyBytes));
      for (int i = 0; i <= jsonData.length - 1; i++) {
        if (jsonData[i]["usuario_id"] == userid) {
          nameUser = jsonData[i]["usuario_nombre"] +
              " " +
              jsonData[i]["usuario_apellido"];
        }
      }
    }
    return nameUser;
  }
}
