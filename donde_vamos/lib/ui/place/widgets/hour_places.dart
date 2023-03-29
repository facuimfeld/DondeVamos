import 'package:donde_vamos/models/hour_place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:donde_vamos/utilities/utilites_events.dart';
import 'package:flutter/material.dart';

class HourPlaces extends StatelessWidget {
  const HourPlaces({
    Key? key,
    required this.idLugar,
  }) : super(key: key);

  final int idLugar;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HourPlace>>(
        future: PlacesProvider().getHourFromPlace(idLugar),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('data' + snapshot.data!.toString());
            if (snapshot.data!.isEmpty) {
              return Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text('Sin horarios', style: AppColors().styleBody));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: DataTable(
                    dataRowHeight: 30.0,
                    headingRowHeight: 16,
                    sortColumnIndex: 0,
                    horizontalMargin: 1.0,
                    columnSpacing: 12.5,
                    columns: [
                      DataColumn(
                          label: Text('Dia', style: AppColors().styleBody)),
                      DataColumn(
                          label:
                              Text('H.Mañana', style: AppColors().styleBody)),
                      DataColumn(
                          label: Text('H.Tarde', style: AppColors().styleBody)),
                      // DataColumn(
                      //    label: Text('Corrido', style: AppColors().styleBody))
                    ],
                    rows: snapshot.data!.map((e) {
                      return DataRow(cells: [
                        DataCell(Text(
                            UtilitiesEvent().getDay(e.horarios_lugar_diadesem),
                            style: AppColors().styleBody)),
                        DataCell(Text(
                            e.horarios_lugar_desde_m.toString() == '00:00:00' &&
                                    e.horarios_lugar_hasta_m.toString() ==
                                        "00:00:00"
                                ? 'Cerrado'
                                : e.horarios_lugar_hasta_m.toString() ==
                                        "00:00:00"
                                    ? e.horarios_lugar_desde_m.toString()
                                    : e.horarios_lugar_desde_m.toString() +
                                        '-' +
                                        e.horarios_lugar_hasta_m.toString(),
                            style: AppColors().styleBody)),
                        DataCell(
                            e.horarios_lugar_desde_t.toString() == '00:00:00' &&
                                    e.horarios_lugar_hasta_t.toString() ==
                                        '00:00:00'
                                ? Text('Cerrado', style: AppColors().styleBody)
                                : Text(
                                    e.horarios_lugar_desde_t.toString() ==
                                            "00:00:00"
                                        ? e.horarios_lugar_hasta_t.toString()
                                        : e.horarios_lugar_desde_t.toString() +
                                            '-' +
                                            e.horarios_lugar_hasta_t.toString(),
                                    style: AppColors().styleBody)),
                        /*
                        DataCell(
                          e.horarios_lugar_desde_t.toString() == "00:00:00" &&
                                      e.horarios_lugar_hasta_m.toString() ==
                                          "00:00:00" &&
                                      e.horarios_lugar_desde_m.toString() !=
                                          "00:00:00" &&
                                      e.horarios_lugar_hasta_t.toString() !=
                                          "00:00:00" ||
                                  e.horarios_lugar_desde_m.toString() ==
                                          "00:00:00" &&
                                      e.horarios_lugar_hasta_m
                                              .toString() ==
                                          "12:00:00" &&
                                      e
                                              .horarios_lugar_desde_t
                                              .toString() ==
                                          "12:00:00" &&
                                      e
                                              .horarios_lugar_hasta_t
                                              .toString() ==
                                          "23:59:00"
                              ? Text('Si', style: AppColors().styleBody)
                              : e
                                              .horarios_lugar_desde_t
                                              .toString() ==
                                          "00:00:00" &&
                                      e
                                              .horarios_lugar_hasta_m
                                              .toString() ==
                                          "00:00:00" &&
                                      e.horarios_lugar_desde_m.toString() ==
                                          "00:00:00" &&
                                      e.horarios_lugar_hasta_t.toString() ==
                                          "00:00:00"
                                  ? Text('-', style: AppColors().styleBody)
                                  : Text('No', style: AppColors().styleBody),
                        )*/
                      ]);
                    }).toList()),
              ),
            );
          }
          return CircularProgressIndicator();
        });
  }
}
