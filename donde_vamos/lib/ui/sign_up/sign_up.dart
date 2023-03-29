// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:donde_vamos/firebase/cloud_firestore.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/user.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> registerUser(Map<String, dynamic> user) async {
    //String url = 'http://10.0.3.2:8000/api/suscribe-lugar/';
    String url = 'http://10.0.3.2:8000/api/usuarios/';
    user["usuario_tipo"] = 's';
    var resp = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode(user));
    print('status code' +
        resp.statusCode.toString() +
        "  " +
        resp.body.toString());
    if (resp.statusCode == 201) {
      print('usuario registrado!');
      /*
      setState(() {
        isLoading = false;
      });*/
      print('user' + user.toString());
      await LocalPreferences().setValueLogged();
      await LocalPreferences().setUsername(user["usuario_id"]);
      await LocalPreferences().setNameUser(user["usuario_nombre"].toString() +
          " " +
          user["usuario_apellido"].toString());
    } else {
      print(resp.body.toString());
    }
  }

  bool isHide = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nuevo usuario', style: GoogleFonts.mavenPro()),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.3,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text('\@')),
                    SizedBox(width: 5.0),
                    Flexible(
                      flex: 1,
                      child: TextField(
                          controller: username,
                          decoration: InputDecoration(
                            labelText: 'Nombre de usuario',
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: TextField(
                    controller: surname,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: TextField(
                    obscureText: isHide,
                    controller: password,
                    decoration: InputDecoration(
                      suffixIcon: isHide
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  isHide = !isHide;
                                });
                              },
                              icon: Icon(Icons.lock))
                          : IconButton(
                              icon: Icon(Icons.lock_open),
                              onPressed: () {
                                setState(() {
                                  isHide = !isHide;
                                });
                              },
                            ),
                      labelText: 'Contraseña',
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    )),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (name.text.isEmpty &&
                      username.text.isEmpty &&
                      surname.text.isEmpty &&
                      password.text.isEmpty &&
                      email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        Text('Debes completar todos los campos del formulario'),
                      ],
                    )));
                  } else {
                    Map<String, dynamic> data = {};
                    data["usuario_id"] = username.text;
                    data["usuario_nombre"] = name.text;
                    data["usuario_apellido"] = surname.text;
                    data["usuario_contraseña"] = password.text;
                    data["usuario_email"] = email.text;
                    data["usuario_tipo"] = 's';
                    // String tokenId = await Notifications().getUserTokenId();
                    // print('token id' + tokenId.toString());
                    // CloudFirestore().addTokenId(username.text, tokenId);
                    //User user = User.fromJSON(data);
                    await LocalPreferences().changeValueLogged(true);
                    //await LocalPreferences().setNameUser(username.text);
                    //await LocalPreferences().setUsername(username.text);
                    print('datau' + data.toString());
                    await registerUser(data).whenComplete(() {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 17.0),
                          Text('Usuario registrado!'),
                        ],
                      )));
                      // Navigator.push(context,
                      //  MaterialPageRoute(builder: (context) => Home()));
                    });
                  }

                  //Notifications().initPlatformState().whenComplete(() async {

                  //});
                },
                child: Text('Registrarme'))),
      ],
    );
  }
}
