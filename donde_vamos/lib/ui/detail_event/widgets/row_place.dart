// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:donde_vamos/models/event.dart';
import 'package:donde_vamos/models/place.dart';
import 'package:donde_vamos/resources/places_provider.dart';
import 'package:donde_vamos/ui/place/detail_place.dart';
import 'package:donde_vamos/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RowPlace extends StatefulWidget {
  Event event;
  RowPlace({required this.event});

  @override
  State<RowPlace> createState() => _RowPlaceState();
}

class _RowPlaceState extends State<RowPlace> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailPlace(idLugar: widget.event.evento_lugar)));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.home, color: Colors.grey.withOpacity(0.25), size: 18.0),
            const SizedBox(width: 5.0),
            FutureBuilder<Place>(
                future: PlacesProvider().getPlace(widget.event.evento_lugar),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(snapshot.data!.lugar_nombre.toString(),
                        style: AppColors().styleBody);
                  }
                  return Shimmer.fromColors(
                      child: SizedBox(
                        height: 20,
                        width: 100,
                      ),
                      baseColor: Colors.grey,
                      highlightColor: Colors.white);
                  //return const CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
