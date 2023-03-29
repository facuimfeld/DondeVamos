// ignore_for_file: use_build_context_synchronously

import 'package:donde_vamos/firebase/cloud_firestore.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/notifications/notifications.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/login/widgets/error_login.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSignIn extends StatefulWidget {
  String usuario;
  String password;
  ButtonSignIn({required this.usuario, required this.password});

  @override
  State<ButtonSignIn> createState() => _ButtonSignInState();
}

class _ButtonSignInState extends State<ButtonSignIn> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: GestureDetector(
        onTap: () async {
          print('user' + widget.usuario);
          print('pass' + widget.password);
          bool exists =
              await UserProvider().verifyUser(widget.usuario, widget.password);
          if (exists == true) {
            await LocalPreferences().setValueLogged().whenComplete(() async {
              await LocalPreferences().setNameUser(widget.usuario);
              await LocalPreferences().setUsername(widget.usuario);
              await Notifications().initPlatformState().whenComplete(() async {
                String tokenId = await Notifications().getUserTokenId();
                print('token id' + tokenId.toString());
                await CloudFirestore().addTokenId(widget.usuario, tokenId);
              });

              Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()))
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
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
