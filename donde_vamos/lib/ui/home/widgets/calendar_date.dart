// ignore_for_file: prefer_const_constructors

import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/resources/dates_provider.dart';
//import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarDate extends StatefulWidget {
  int idEvento;
  CalendarDate({required this.idEvento});
  @override
  State<CalendarDate> createState() => _CalendarDateState();
}

class _CalendarDateState extends State<CalendarDate> {
  late DateTime comingDate;
  late String formatedDate;

  @override
  void initState() {
    calculateComingDate();
    super.initState();
  }

  Future<void> calculateComingDate() async {
    comingDate = await DatesProvider().getComingDate(widget.idEvento);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(comingDate);
    formatedDate = formatted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DateTime>(
        future: DatesProvider().getComingDate(widget.idEvento),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //DateEvent date = snapshot.data![0];
            bool existsNextDate = false;
            if (DateTime.now().difference(snapshot.data!).inDays < 0) {
              existsNextDate = true;
            }

            return Container(
              margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendar,
                    color: Colors.grey.withOpacity(0.25),
                    size: 14.0,
                  ),
                  SizedBox(width: 5.0),
                  Text('Proxima Fecha: ',
                      style: GoogleFonts.mavenPro(
                          color: Colors.grey.withOpacity(0.55),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(width: 5.0),
                  existsNextDate == true
                      ? Text(Dates().convertDateToString(snapshot.data!),
                          style: AppColors().styleBody)
                      : Text('No hay proximas fechas',
                          style: AppColors().styleBody)
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
