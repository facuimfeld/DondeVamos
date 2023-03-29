// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:donde_vamos/local/local_preferences.dart';
import 'package:donde_vamos/resources/categories_provider.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/resources/provinces_provider.dart';
import 'package:donde_vamos/ui/home/home.dart';
//import 'package:donde_vamos/resources/event_provider.dart';
import 'package:donde_vamos/ui/results_filter/results_filter.dart';
import 'package:donde_vamos/ui/results_filter_places/results_filter_places.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AlertDialogFilter extends StatefulWidget {
  const AlertDialogFilter({Key? key}) : super(key: key);

  @override
  State<AlertDialogFilter> createState() => _AlertDialogFilterState();
}

class _AlertDialogFilterState extends State<AlertDialogFilter> {
  int index = 0;
  double distance = 1.0;
  @override
  void initState() {
    super.initState();
    setDistance();
  }

  Future<void> setDistance() async {
    distance = await LocalPreferences().getDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.75,
          child: DefaultTabController(
            length: 3,
            initialIndex: index,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 8,
                elevation: 0,
                bottom: TabBar(tabs: [
                  Tab(
                    child:
                        Text('EVENTOS', style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                      child: Text('LUGARES',
                          style: TextStyle(color: Colors.black))),
                  Tab(
                    child:
                        Text('AJUSTES', style: TextStyle(color: Colors.black)),
                  ),
                ]),
              ),
              body: TabBarView(children: [
                EventsFilter(index: index),
                PlacesFilter(index: index),
                Settings(distance: distance),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class Settings extends StatefulWidget {
  double distance;
  Settings({required this.distance});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    setDistance().then((value) => setState(() {}));
  }

  Future<void> setDistance() async {
    widget.distance = await LocalPreferences().getDistance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Text('Radio de busqueda de evento' +
              " " +
              widget.distance.toInt().toString() +
              " " +
              "Km"),
        ),
        Slider(
            label: widget.distance.toInt().toString(),
            max: 151.0,
            min: 1.0,
            value: widget.distance,
            // divisions: 1,
            onChanged: (val) {
              setState(() {
                widget.distance = val;
              });
            }),
        SizedBox(height: 15.0),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                await LocalPreferences().modifyDistance(widget.distance);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
              child: Text('Guardar cambios')),
        )
      ],
    );
  }
}

class PlacesFilter extends StatefulWidget {
  int index;
  PlacesFilter({required this.index});
  @override
  State<PlacesFilter> createState() => _PlacesFilterState();
}

class _PlacesFilterState extends State<PlacesFilter> {
  String placeValue = 'Todos';
  bool activeAllPlaces = false;
  TextEditingController namePlace = TextEditingController();
  var gastronomicValues = ["Bar", "Restaurante"];
  String gastronomicValue = "Bar";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: TextField(
            controller: namePlace,
            textAlign: TextAlign.center,
            decoration: InputDecoration.collapsed(
                hintStyle: GoogleFonts.mavenPro(fontWeight: FontWeight.w500),
                hintText: 'Ingresa un lugar...'),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
          child: Text('Tipo de lugar',
              style: GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
        ),
        FutureBuilder<List<String>>(
            future: PlacesProvider().getTypePlaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: IgnorePointer(
                      ignoring: activeAllPlaces,
                      child: DropdownButton<String>(
                        menuMaxHeight: 200.0,
                        value: placeValue,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: snapshot.data!.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            placeValue = val.toString();
                          });
                        },
                      ),
                    ));
              }
              return CircularProgressIndicator();
            }),
        placeValue == "Gastronomico"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text('Tipo de lugar gastronomico',
                        style:
                            GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: DropdownButton<String>(
                        menuMaxHeight: 200.0,
                        value: gastronomicValue,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: gastronomicValues.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            gastronomicValue = val.toString();
                          });
                        },
                      )),
                ],
              )
            : Container(),
        /*
        Container(
          margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buscar todos los tipos de lugares',
                  style: GoogleFonts.mavenPro(fontWeight: FontWeight.w500)),
              Checkbox(
                  value: activeAllPlaces,
                  onChanged: (val) {
                    setState(() {
                      activeAllPlaces = val!;
                    });
                  })
            ],
          ),
        ),*/
        SizedBox(height: 85.0),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultsFilterPlaces(
                                namePlace: namePlace.text,
                                gastronomicPlace: gastronomicValue,
                                selectedTypePlace: placeValue,
                                allEvents: activeAllPlaces,
                              )));
                },
                child: Text('Buscar lugares'))),
      ],
    );
  }
}

class EventsFilter extends StatefulWidget {
  int index;
  EventsFilter({required this.index});
  @override
  State<EventsFilter> createState() => _EventsFilterState();
}

class _EventsFilterState extends State<EventsFilter> {
  String valueCategory = 'Todas';
  bool isFree = false;
  String formattedDesde = 'dd/mm/yyyy';
  String formattedHasta = 'dd/mm/yyyy';
  TextEditingController nameEvent = TextEditingController();
  DateTime? pickedDateDesde;
  DateTime? pickedDateHasta;
  String stateProvince = "Todas";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextField(
              controller: nameEvent,
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                  hintStyle: GoogleFonts.mavenPro(fontWeight: FontWeight.w500),
                  hintText: 'Ingresa un nombre...'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text('Categoria',
                style: GoogleFonts.mavenPro(
                    fontSize: 15.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 30, 0),
            child: FutureBuilder<List<String>>(
                future: CategoriesProvider().getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return DropdownButton<String>(
                      menuMaxHeight: 200.0,
                      value: valueCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: snapshot.data!.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          valueCategory = val.toString();
                        });
                      },
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
          /*
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text('Provincia',
                style: GoogleFonts.mavenPro(
                    fontSize: 15.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 30, 0),
            child: FutureBuilder<List<String>>(
                future: ProvincesProvider().getProvinces(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return DropdownButton<String>(
                      menuMaxHeight: 200.0,
                      value: stateProvince,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: snapshot.data!.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          stateProvince = val.toString();
                        });
                      },
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),*/
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
            child: Row(
              children: [
                Text('Gratuito',
                    style: GoogleFonts.mavenPro(
                        fontSize: 15.0, fontWeight: FontWeight.w500)),
                Checkbox(
                    value: isFree,
                    onChanged: (val) {
                      setState(() {
                        isFree = !isFree;
                      });
                    })
              ],
            ),
          ),
          Divider(
            indent: 25.0,
            endIndent: 10.0,
            color: Colors.grey.withOpacity(0.5),
            thickness: 0.6,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text('Periodo de fecha (opcional)',
                style: GoogleFonts.mavenPro(
                    fontSize: 15.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Fecha desde
                GestureDetector(
                  onTap: () async {
                    pickedDateDesde = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    if (pickedDateDesde == null) return;
                    setState(() {
                      formattedDesde =
                          DateFormat('dd-MM-yyyy').format(pickedDateDesde!);
                    });
                    print('fecha format' + formattedDesde);
                  },
                  child: Container(
                    height: 40,
                    child: Center(
                        child: Text(formattedDesde,
                            style: TextStyle(fontSize: 16.0))),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                    ),
                    width: 120.0,
                  ),
                ),
                SizedBox(width: 5.0),
                //Fecha hasta
                GestureDetector(
                  onTap: () async {
                    pickedDateHasta = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));
                    if (pickedDateHasta == null) return;
                    setState(() {
                      formattedHasta =
                          DateFormat('dd-MM-yyyy').format(pickedDateHasta!);
                    });
                    print('fecha format' + formattedHasta);
                  },
                  child: Container(
                    height: 40,
                    child: Center(
                        child: Text(formattedHasta,
                            style: TextStyle(fontSize: 16.0))),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                    ),
                    width: 120.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 45.0),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultsFilter(
                                  valueCategory: valueCategory,
                                  fechaDesde: formattedDesde,
                                  nameEvent: nameEvent.text,
                                  isEvent: true,
                                  province: stateProvince,
                                  fechaHasta: formattedHasta,
                                  isFree: isFree,
                                )));
                  },
                  child: Text('Buscar eventos'))),
        ],
      ),
    );
  }
}
