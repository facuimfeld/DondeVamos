import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/suscription_event.dart';
import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/resources/suscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuscriptionsEvent extends StatefulWidget {
  SuscriptionsEvent({Key? key}) : super(key: key);

  @override
  State<SuscriptionsEvent> createState() => _SuscriptionsEventState();
}

class _SuscriptionsEventState extends State<SuscriptionsEvent> {
  Future<List<Event>> getEvents() async {
    List<Event> events = [];
    List<SuscriptionEvent> suscripEvents =
        await SuscriptionProvider().getSuscriptions();
    for (int i = 0; i <= suscripEvents.length - 1; i++) {
      Event event = await EventProvider()
          .getEventByID(suscripEvents[i].suscribe_evento_evento_id);
      events.add(event);
    }

    return events;
  }

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text('Todavia no te has suscrito a ningun evento',
                      style: GoogleFonts.mavenPro(
                          fontSize: 16.0, fontWeight: FontWeight.w500)));
            }
            return DataTable(
                columnSpacing: 155.0,
                columns: [
                  DataColumn(
                    label: Text('Evento',
                        style:
                            GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
                  ),
                  DataColumn(
                    label: Text('Estado',
                        style:
                            GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
                  )
                ],
                rows: snapshot.data!.map((e) {
                  return DataRow(cells: [
                    DataCell(Text(e.evento_nombre,
                        style:
                            GoogleFonts.mavenPro(fontWeight: FontWeight.w500))),
                    DataCell(Text(e.evento_estado,
                        style: GoogleFonts.mavenPro(
                            color: e.evento_estado == "A iniciar"
                                ? Colors.green
                                : e.evento_estado == "Suspendido"
                                    ? Colors.red
                                    : Colors.grey,
                            fontWeight: FontWeight.w500))),
                  ]);
                }).toList());
            /*
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].evento_nombre,
                          style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.w500)),
                      trailing: Text(snapshot.data![index].evento_estado,
                          style: GoogleFonts.mavenPro(
                              fontWeight: FontWeight.w500)),
                    );
                  });*/
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
