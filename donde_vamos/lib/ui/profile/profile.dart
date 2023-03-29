// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/user.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:donde_vamos/ui/profile/widgets/alert_dialog_edit_data.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String username = '';
  String name = '';
  int index = 0;
  bool isHide = true;
  @override
  void initState() {
    super.initState();
  }

  Future<User> getDataUser() async {
    username = await LocalPreferences().getUsername();
    name = await LocalPreferences().getNameUser();
    index = name.indexOf(' ');
    return await UserProvider().getUser(username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //var regex = RegExp(r'^[a-zA-Z0-9]+$');
            int lengthpass =
                snapshot.data!.usuario_contrasenia.toString().length;
            String password = snapshot.data!.usuario_contrasenia
                .toString()
                .replaceRange(0, lengthpass, "*" * lengthpass);

            return FadeInLeft(
              duration: Duration(
                milliseconds: 700,
              ),
              child: Column(
                children: [
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: Center(
                              child: CircleAvatar(
                            radius: 75.0,
                            child: Center(
                                child: Text(
                              name.substring(0, 1).toUpperCase() +
                                  name.substring(index + 1, index + 2),
                              style: GoogleFonts.mavenPro(
                                  fontWeight: FontWeight.w500, fontSize: 50.0),
                            )),
                            backgroundColor: Colors.black,
                          ))),
                      flex: 4),
                  Expanded(
                      child: Container(
                          color: Colors.white,
                          child: Flexible(
                              child: ListView(
                                children: [
                                  ListTile(
                                      trailing: IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      subtitle: Text(
                                          snapshot.data!.usuario_id.toString(),
                                          style: GoogleFonts.mavenPro(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontWeight: FontWeight.w500)),
                                      title: Text('Nombre de usuario',
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                  ListTile(
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialogEditDataUser(
                                                    userData: snapshot.data!,
                                                    postEdit: 2,
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      subtitle: Text(
                                          snapshot.data!.usuario_email,
                                          style: GoogleFonts.mavenPro(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontWeight: FontWeight.w500)),
                                      title: Text('Email',
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                  ListTile(
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialogEditDataUser(
                                                    userData: snapshot.data!,
                                                    postEdit: 3,
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      subtitle: Text(password,
                                          style: GoogleFonts.mavenPro(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontWeight: FontWeight.w500)),
                                      title: Text('Contraseña',
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                  ListTile(
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialogEditDataUser(
                                                    userData: snapshot.data!,
                                                    postEdit: 4,
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      subtitle: Text(
                                          snapshot.data!.usuario_nombre
                                              .toString(),
                                          style: GoogleFonts.mavenPro(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontWeight: FontWeight.w500)),
                                      title: Text('Nombre',
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                  ListTile(
                                      trailing: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialogEditDataUser(
                                                    userData: snapshot.data!,
                                                    postEdit: 5,
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      subtitle: Text(
                                          snapshot.data!.usuario_apellido
                                              .toString(),
                                          style: GoogleFonts.mavenPro(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontWeight: FontWeight.w500)),
                                      title: Text('Apellido',
                                          style: GoogleFonts.mavenPro(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500))),
                                ],
                              ),
                              flex: 1)),
                      flex: 7),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
