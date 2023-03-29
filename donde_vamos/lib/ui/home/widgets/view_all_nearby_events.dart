import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/ui/home/widgets/card_nearby_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllNearbyEvents extends StatefulWidget {
  const ViewAllNearbyEvents({Key? key}) : super(key: key);

  @override
  State<ViewAllNearbyEvents> createState() => _ViewAllNearbyEventsState();
}

class _ViewAllNearbyEventsState extends State<ViewAllNearbyEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Eventos mas cercanos',
            style: GoogleFonts.mavenPro(
                color: Colors.white, fontWeight: FontWeight.w500)),
      ),
      body: FadeInLeft(
          duration: Duration(milliseconds: 700),
          child: FutureBuilder<List<Event>>(
              future: EventProvider().getNearbyEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return CardNearbyEvent(event: snapshot.data![index]);
                      });
                }
                return Center(child: CircularProgressIndicator());
              })),
    );
  }
}
