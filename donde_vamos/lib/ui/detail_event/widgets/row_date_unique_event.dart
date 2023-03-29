import 'package:donde_vamos/models/date.dart';
//import 'package:donde_vamos/models/event.dart';
//import 'package:donde_vamos/resources/dates_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class RowDateUniqueEvent extends StatefulWidget {
  DateEvent diaEvento;
  RowDateUniqueEvent({required this.diaEvento});

  @override
  State<RowDateUniqueEvent> createState() => _RowDateUniqueEventState();
}

class _RowDateUniqueEventState extends State<RowDateUniqueEvent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_month,
                color: Colors.grey.withOpacity(0.25), size: 18.0),
            const SizedBox(width: 5.0),
            Text(widget.diaEvento.fecha_evento_dia,
                style: AppColors().styleBody)
          ]),
    );
  }
}
