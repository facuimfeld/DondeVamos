// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/firebase/cloud_firestore.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/user.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/login/widgets/background_image.dart';
import 'package:donde_vamos/ui/login/widgets/button_create_account.dart';
import 'package:donde_vamos/ui/login/widgets/button_sign_in.dart';
import 'package:donde_vamos/ui/login/widgets/error_login.dart';
import 'package:donde_vamos/ui/sign_up/sign_up.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:themed/themed.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usuario = TextEditingController();

  TextEditingController contrasenia = TextEditingController();
  bool isLogged = false;
  bool isHide = true;
  @override
  void initState() {
    super.initState();
    getValueLogged();
  }

  Future<void> getValueLogged() async {
    isLogged = await LocalPreferences().getValueLogged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: isLogged
            ? Container()
            : IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.black,
        // automaticallyImplyLeading: isLogged ? false : true,
      ),
      body: SafeArea(
        child: FadeInLeft(
          duration: Duration(milliseconds: 700),
          child: Stack(
            children: [
              BackgroundImage(),
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                            child: Text('Iniciar Sesion en Vamos?',
                                style: GoogleFonts.mavenPro(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w200))),
                        const SizedBox(height: 50.0),
                        Container(
                          margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Email'),
                              Spacer(),
                              Tooltip(
                                message:
                                    'Tu nombre de usuario se define por @nombreusuario',
                                child: Icon(
                                  Icons.info,
                                  size: 18.0,
                                  color: Colors.grey.withOpacity(0.40),
                                ),
                              ),
                              SizedBox(width: 35.0),
                            ],
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                          child: SizedBox(
                            height: 50.0,
                            child: TextField(
                              controller: usuario,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.2),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          margin: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                          child: const Text('Contraseña'),
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                          child: SizedBox(
                            height: 50.0,
                            child: TextField(
                              controller: contrasenia,
                              obscureText: isHide,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isHide = !isHide;
                                      });
                                    },
                                    icon: isHide
                                        ? Icon(Icons.lock, size: 20.0)
                                        : Icon(Icons.lock_open)),
                                hintText: 'Contraseña',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.2),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: GestureDetector(
                            onTap: () async {
                              //print('user' + widget.usuario);
                              // print('pass' + widget.password);
                              bool exists = await UserProvider()
                                  .verifyUser(usuario.text, contrasenia.text);
                              if (exists == true) {
                                await LocalPreferences()
                                    .setValueLogged()
                                    .whenComplete(() async {
                                  User user = await UserProvider()
                                      .getUserFromEmail(usuario.text);
                                  await LocalPreferences()
                                      .setNameUser(user.usuario_id);
                                  await LocalPreferences()
                                      .setUsername(user.usuario_id);
                                  await Notifications()
                                      .initPlatformState()
                                      .whenComplete(() async {
                                    String tokenId =
                                        await Notifications().getUserTokenId();
                                    print('token id' + tokenId.toString());
                                    //await CloudFirestore()
                                    //    .addTokenId(usuario.text, tokenId);
                                  });

                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home()))
                                      .then((value) {});
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ErrorLogin();
                                    });
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.30,
                              decoration: BoxDecoration(
                                gradient: AppColors().gradient,
                              ),
                              child: Center(
                                child: Text('Iniciar Sesion',
                                    style: GoogleFonts.mavenPro(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        ButtonCreateAccount(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
