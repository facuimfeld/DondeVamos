import 'package:donde_vamos/device/maps.dart';
import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowDirectionPlace extends StatefulWidget {
  int idPlace;
  RowDirectionPlace({required this.idPlace});

  @override
  State<RowDirectionPlace> createState() => _RowDirectionPlaceState();
}

class _RowDirectionPlaceState extends State<RowDirectionPlace> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.room, color: Colors.grey.withOpacity(0.25), size: 18.0),
          const SizedBox(width: 5.0),
          FutureBuilder<Place>(
              future: PlacesProvider().getPlace(widget.idPlace),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String direccion = snapshot.data!.lugar_calle
                      .toString()
                      .replaceAll('Avenida', 'Av.');
                  direccion = direccion.replaceAll('General', 'Gral.');
                  return GestureDetector(
                    onTap: () async {
                      double lat;
                      double lng;
                      String direction = snapshot.data!.lugar_calle.toString() +
                          " " +
                          snapshot.data!.lugar_numero.toString() +
                          "," +
                          " " +
                          snapshot.data!.localidad_nombre.toString() +
                          "," +
                          snapshot.data!.localidad_provincia.toString();
                      Maps.openGoogleMaps(direction);
                    },
                    child: Text(
                        direccion +
                            " " +
                            snapshot.data!.lugar_numero.toString() +
                            "," +
                            " " +
                            snapshot.data!.localidad_nombre.toString(),
                        style: GoogleFonts.mavenPro(
                            decoration: TextDecoration.underline,
                            fontSize: 13.0,
                            color: Colors.blue.withOpacity(0.6),
                            fontWeight: FontWeight.w800)),
                  );
                }
                return const CircularProgressIndicator();
              }),
        ],
      ),
    );
  }
}
