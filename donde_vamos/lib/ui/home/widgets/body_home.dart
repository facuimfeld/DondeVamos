//import 'package:donde_vamos/ui/home/widgets/card_event.dart';
import 'package:donde_vamos/ui/home/widgets/label_current_events.dart';
import 'package:donde_vamos/ui/home/widgets/label_general_events.dart';
import 'package:donde_vamos/ui/home/widgets/label_nearby_events.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({Key? key}) : super(key: key);

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LabelNearbyEvents(),
                Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(15, 30, 20, 0),
                    child: Text('VER MAS',
                        style: GoogleFonts.mavenPro(
                            color: Colors.pink, fontWeight: FontWeight.bold))),
              ],
            ),
            /*
            FutureBuilder<List<Event>>(
                future: EventProvider().getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return CardEvent();
                          }),
                    );
                  }
                  return CircularProgressIndicator();
                }),*/

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LabelCurrentEvents(),
                Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(15, 30, 20, 0),
                    child: Text('VER MAS',
                        style: GoogleFonts.mavenPro(
                            color: Colors.pink, fontWeight: FontWeight.bold))),
              ],
            ),
            const LabelGeneralEvents(),
          ],
        ),
      ),
    ]));
  }
}
