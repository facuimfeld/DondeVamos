// ignore_for_file: prefer_const_constructors

//import 'package:donde_vamos/blocs/event_bloc/event_bloc.dart';
import 'package:donde_vamos/models/hour_event.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarDays extends StatefulWidget {
  int idEvento;
  CalendarDays({required this.idEvento});
  @override
  State<CalendarDays> createState() => _CalendarDaysState();
}

class _CalendarDaysState extends State<CalendarDays> {
  List<String> days = [];
  @override
  void initState() {
    super.initState();
    assignDays();
    //  BlocProvider.of<EventBloc>(context)
    //  .add(GetDaysFromEvent(idEvento: widget.idEvento));
  }

  Future<void> assignDays() async {
    List<HourEvent> hoursEvents =
        await DatesProvider().getDaysFromEvent(widget.idEvento);
    for (int i = 0; i <= hoursEvents.length - 1; i++) {
      days.add(hoursEvents[i].horarios_eventos_diadesem.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
      child: FutureBuilder(
        future: assignDays(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FaIcon(
                  FontAwesomeIcons.calendar,
                  color: Colors.grey.withOpacity(0.25),
                  size: 14.0,
                ),
                SizedBox(width: 5.0),
                Text('D',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('D')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('L',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('L')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('M',
                    style: GoogleFonts.mavenPro(
                        fontSize: 12.0,
                        color: days.contains('M')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('X',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('X')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('J',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('J')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('V',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('V')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5.0),
                Text('S',
                    style: GoogleFonts.mavenPro(
                        fontSize: 13.0,
                        color: days.contains('S')
                            ? Colors.black
                            : Colors.grey.withOpacity(0.55),
                        fontWeight: FontWeight.w500)),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
