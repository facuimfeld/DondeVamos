import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/models/user.dart';
import 'package:donde_vamos/resources/user_provider.dart';
import 'package:donde_vamos/ui/home/home.dart';
import 'package:donde_vamos/ui/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class AlertDialogEditDataUser extends StatefulWidget {
  User userData;
  int postEdit;
  AlertDialogEditDataUser({required this.userData, required this.postEdit});

  @override
  State<AlertDialogEditDataUser> createState() =>
      _AlertDialogEditDataUserState();
}

class _AlertDialogEditDataUserState extends State<AlertDialogEditDataUser> {
  TextEditingController dataEdit = TextEditingController();
  String hideText = '';
  bool hidePassword = true;
  @override
  void initState() {
    ToastContext().init(context);
    switch (widget.postEdit) {
      case 2:
        dataEdit.text = widget.userData.usuario_email;
        break;
      case 3:
        dataEdit.text = widget.userData.usuario_contrasenia.toString();
        hideText = dataEdit.text.toString().replaceRange(
            0, dataEdit.text.toString().length, '*' * dataEdit.text.length);

        break;
      case 4:
        dataEdit.text = widget.userData.usuario_nombre;
        break;
      case 5:
        dataEdit.text = widget.userData.usuario_apellido;
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: AlertDialog(
        title: Text('Edicion de perfil', style: GoogleFonts.mavenPro()),
        content: SizedBox(
            height: 200,
            width: 300,
            child: Container(
                margin: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                      /*
                    suffixIcon: widget.postEdit == 3
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                              if (hidePassword == true) {
                                setState(() {
                                  dataEdit.text = hideText;
                                });
                              } else {
                                setState(() {
                                  dataEdit.text =
                                      widget.userData.usuario_contrasenia;
                                });
                              }
                            },
                            icon: hidePassword
                                ? Icon(Icons.lock, size: 22.0)
                                : Icon(Icons.lock_open, size: 22.0))
                        : Container(),*/
                      ),
                  controller: dataEdit,
                  keyboardType:
                      widget.postEdit == 2 ? TextInputType.emailAddress : null,
                ))),
        actions: [
          ElevatedButton(
              onPressed: () async {
                switch (widget.postEdit) {
                  case 2:
                    widget.userData.usuario_email = dataEdit.text;
                    break;
                  case 3:
                    widget.userData.usuario_contrasenia = dataEdit.text;
                    break;
                  case 4:
                    widget.userData.usuario_nombre = dataEdit.text;
                    break;
                  case 5:
                    widget.userData.usuario_apellido = dataEdit.text;

                    break;
                }

                Map<String, dynamic> dataUser = widget.userData.toMap();

                await UserProvider().editDataUser(dataUser).then((value) async {
                  setState(() {
                    actualIndex = 2;
                  });
                  await LocalPreferences().changeNameUser(
                      widget.userData.usuario_nombre +
                          " " +
                          widget.userData.usuario_apellido);
                  setState(() {
                    Home();
                  });
                }).whenComplete(() {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                });

                Toast.show("Datos actualizados",
                    duration: Toast.lengthLong, gravity: Toast.bottom);
              },
              child: Text('Guardar cambios')),
        ],
      ),
    );
  }
}
