// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEvent extends StatefulWidget {
  //String direction;
  MapEvent({required this.lat, required this.lng});
  final double lat;
  final double lng;
  @override
  State<MapEvent> createState() => _MapEventState();
}

class _MapEventState extends State<MapEvent> {
  @override
  void initState() {
    super.initState();
  }

  late GoogleMapController _controller;

  final Set<Marker> _markers = {};

  Future<void> _onMapCreated() async {
    //_controller = controller;
    _markers.add(
      Marker(
        infoWindow: InfoWindow(title: 'El evento esta aqui'),
        //icon: BitmapDescriptor.defaultMarker,
        markerId: const MarkerId("id-1"),
        position: LatLng(widget.lat, widget.lng),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/marker.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        duration: const Duration(milliseconds: 700),
        child: SafeArea(
          child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                  zoom: 40.0, target: LatLng(widget.lat, widget.lng)),
              markers: _markers,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                setState(() {
                  _onMapCreated();
                });
              }),
        ),
      ),
    );
  }
}
