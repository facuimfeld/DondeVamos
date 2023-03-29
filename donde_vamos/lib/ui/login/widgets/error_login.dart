// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorLogin extends StatefulWidget {
  const ErrorLogin({Key? key}) : super(key: key);

  @override
  State<ErrorLogin> createState() => _ErrorLoginState();
}

class _ErrorLoginState extends State<ErrorLogin> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error!'),
      content: Text('Error de autenticación, verifica tus credenciales'),
    );
  }
}
