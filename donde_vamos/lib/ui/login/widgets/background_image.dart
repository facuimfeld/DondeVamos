import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
//import 'package:themed/themed.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*ChangeColors(
      brightness: -0.4,
      hue: 0,
      child:*/
        Image.network(
      'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      height: MediaQuery.of(context).size.height,
      /*),*/
    );
  }
}
