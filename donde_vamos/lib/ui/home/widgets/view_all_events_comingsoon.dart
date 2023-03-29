import 'package:animate_do/animate_do.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/detail_event/detail_event.dart';
import 'package:donde_vamos/ui/home/widgets/card_event.dart';
import 'package:flutter/material.dart';

class ViewAllEventsSoon extends StatefulWidget {
  List<Event> events;
  ViewAllEventsSoon({required this.events});
  @override
  State<ViewAllEventsSoon> createState() => _ViewAllEventsSoonState();
}

class _ViewAllEventsSoonState extends State<ViewAllEventsSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: FadeInLeft(
        duration: const Duration(milliseconds: 700),
        child: ListView.builder(
            itemCount: widget.events.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailEvent(event: widget.events[index])));
                  },
                  child: CardEvent(widget.events[index]));
              /*
              return ListTile(
                  title: Text(widget.events[index].evento_nombre),
                  subtitle: FutureBuilder<Place>(
                      future: PlacesProvider()
                          .getPlace(widget.events[index].evento_lugar),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Row(
                            children: [
                              Icon(Icons.room, size: 15.0),
                              Text(snapshot.data!.lugar_nombre.toString()),
                            ],
                          );
                        }
                        return CircularProgressIndicator();
                      }));*/
            }),
      ),
    );
  }
}
