// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:donde_vamos/firebase/firebase_storage.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImageEvent extends StatefulWidget {
  Event event;
  ImageEvent(this.event);

  @override
  State<ImageEvent> createState() => _ImageEventState();
}

class _ImageEventState extends State<ImageEvent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            child: FutureBuilder<dynamic>(
                future: FirebaseStorage()
                    .getURLImageEvent(widget.event.evento_nombre.trim()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    bool hasData = true;
                    if (!snapshot.hasData) {
                      setState(() {
                        hasData = false;
                      });
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                            hasData == true
                                ? snapshot.data!
                                : 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Imagen_no_disponible.svg/480px-Imagen_no_disponible.svg.png',
                            fit: BoxFit.cover),
                        Positioned(
                            left: 3.0,
                            top: 2.0,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back,
                                    color: Colors.white))),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                }),
            color: Colors.red,
            width: MediaQuery.of(context).size.width),
        flex: 1);
  }
}
