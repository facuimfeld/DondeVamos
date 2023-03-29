// ignore_for_file: prefer_const_constructors

import 'package:donde_vamos/ui/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonCreateAccount extends StatefulWidget {
  const ButtonCreateAccount({Key? key}) : super(key: key);

  @override
  State<ButtonCreateAccount> createState() => _ButtonCreateAccountState();
}

class _ButtonCreateAccountState extends State<ButtonCreateAccount> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return SignUp();
            });
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Text('Crear Cuenta',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline))),
    );
  }
}
