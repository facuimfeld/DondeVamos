// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/suscription_event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:donde_vamos/ui/home/widgets/card_event.dart';
import 'package:donde_vamos/ui/suscriptions/widgets/suscriptions_events.dart';
import 'package:donde_vamos/ui/suscriptions/widgets/suscriptions_places.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Suscriptions extends StatefulWidget {
  Suscriptions({Key? key}) : super(key: key);

  @override
  State<Suscriptions> createState() => _SuscriptionsState();
}

class _SuscriptionsState extends State<Suscriptions> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> screens = [
    Center(child: Text('1')),
    Center(child: Text('2')),
  ];

  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: tabIndex == 0
            ? Text('Eventos suscriptos')
            : Text('Lugares suscriptos'),
      ),*/
      body: tabIndex == 0 ? SuscriptionsEvent() : SuscriptionsPlaces(),
      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: GoogleFonts.mavenPro(fontWeight: FontWeight.w500),
          currentIndex: tabIndex,
          onTap: (newIndex) {
            print('tab' + newIndex.toString());
            setState(() {
              tabIndex = newIndex;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.event,
                color: Colors.grey,
              ),
              label: 'Eventos',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.place,
                  color: Colors.grey,
                ),
                label: 'Lugares')
          ]),
    );
  }
}
