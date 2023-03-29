import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';

class RowPlace extends StatelessWidget {
  Event event;
  RowPlace(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.room,
              size: 15.0,
              color: Colors.grey.withOpacity(0.65),
            ),
            const SizedBox(width: 5.0),
            FutureBuilder<Place>(
                future: PlacesProvider().getPlace(event.evento_lugar),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String direction = snapshot.data!.lugar_calle
                        .toString()
                        .replaceAll('Avenida', 'Av.');
                    direction = direction.replaceAll('General', 'Gral.');
                    return Text(
                        direction +
                            "," +
                            snapshot.data!.lugar_numero.toString() +
                            " " +
                            snapshot.data!.localidad_nombre.toString(),
                        style: AppColors().styleBody);
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ));
  }
}
