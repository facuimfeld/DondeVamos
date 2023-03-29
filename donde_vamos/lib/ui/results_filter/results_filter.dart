// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';
import 'package:donde_vamos/ui/home/widgets/card_event.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultsFilter extends StatefulWidget {
  bool isEvent;
  String nameEvent;
  String valueCategory;
  bool isFree;
  String fechaDesde;
  String fechaHasta;
  String province;
  ResultsFilter(
      {required this.valueCategory,
      required this.isFree,
      required this.nameEvent,
      required this.isEvent,
      required this.province,
      required this.fechaDesde,
      required this.fechaHasta});

  @override
  State<ResultsFilter> createState() => _ResultsFilterState();
}

class _ResultsFilterState extends State<ResultsFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Busqueda de eventos',
            style: GoogleFonts.mavenPro(
                fontWeight: FontWeight.w500, color: Colors.white)),
      ),
      body: FadeInLeft(
          duration: const Duration(milliseconds: 700),
          child: FutureBuilder<List<Event>>(
              future: EventProvider().getEventsWithFilter(
                  widget.valueCategory,
                  widget.isFree,
                  widget.fechaDesde,
                  widget.fechaHasta,
                  widget.province,
                  widget.nameEvent),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Event> eventsWithFilter =
                      snapshot.data!.toSet().toList();
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text('Sin resultados encontrados'));
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.toSet().toList().length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailEvent(
                                          event: snapshot.data!
                                              .toSet()
                                              .toList()[index])));
                            },
                            child: CardEvent(eventsWithFilter[index]));
                      });
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.pink[200],
                  ),
                );
              })),
    );
  }
}
