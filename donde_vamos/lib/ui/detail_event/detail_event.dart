// ignore_for_file: sort_child_properties_last, prefer_const_constructors, must_be_immutable

//import 'package:donde_vamos/device/gps.dart';
//import 'package:donde_vamos/device/maps.dart';

//import 'package:donde_vamos/resources/event_provider.dart';

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/ui/detail_event/widgets/image_event.dart';
import 'package:donde_vamos/ui/detail_event/widgets/info_event.dart';

import 'package:flutter/material.dart';

class DetailEvent extends StatefulWidget {
  Event event;
  DetailEvent({Key? key, required this.event}) : super(key: key);

  @override
  State<DetailEvent> createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),*/
      body: SafeArea(
        child: FadeInLeft(
          duration: const Duration(milliseconds: 700),
          child: Column(
            children: [
              ImageEvent(widget.event),
              InfoEvent(event: widget.event),
            ],
          ),
        ),
      ),
    );
  }
}
