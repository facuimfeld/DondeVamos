import 'package:donde_vamos/models/date.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:donde_vamos/utilities/dates.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class VariousDates extends StatefulWidget {
  List<DateEvent> dateEvents;
  VariousDates({required this.dateEvents});
  @override
  State<VariousDates> createState() => _VariousDatesState();
}

class _VariousDatesState extends State<VariousDates> {
  var inputFormat = DateFormat('dd/MM/yyyy');
  @override
  void initState() {
    widget.dateEvents
        .sort((a, b) => a.fecha_evento_dia.compareTo(b.fecha_evento_dia));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        dataRowHeight: 30.0,
        headingRowHeight: 16,
        horizontalMargin: 10.0,
        columnSpacing: 20.0,
        columns: [
          DataColumn(label: Text('Fecha', style: AppColors().styleBody)),
          DataColumn(label: Text('Hora Inicio', style: AppColors().styleBody)),
          DataColumn(label: Text('Hora Fin', style: AppColors().styleBody)),
        ],
        rows: widget.dateEvents.map((e) {
          return DataRow(cells: [
            DataCell(Text(Dates().formatDate(e.fecha_evento_dia),
                style: AppColors().styleBody)),
            DataCell(Text(e.fecha_evento_horario_inicio,
                style: AppColors().styleBody)),
            DataCell(
                Text(e.fecha_evento_horario_fin, style: AppColors().styleBody)),
          ]);
        }).toList());
  }
}
