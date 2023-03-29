import 'package:donde_vamos/models/coordinate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Gps {
  //Obtener ubicacion del dispositivo del usuario

  Future<Position> getCoordinatesCurrentLocation() async {
    Position position = Position(
        longitude: -58.97557,
        latitude: -27.44774,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 100.0);

    // Position position = await Geolocator.getCurrentPosition(
    //    desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  //Obtener la distancia a la que se encuentra el evento con respecto a la ubicacion del usuario
  Future<double> distanceEvent(String direction) async {
    print('direction' + direction);
    //Obtener latitud y longitud de la ubicacion del evento
    List<Location> location = await locationFromAddress(direction);

    //Obtener ubicacion del usuario
    Position pos = await getCoordinatesCurrentLocation();

    Coordinate coordEvent = Coordinate(
        latitude: location[0].latitude, longitude: location[0].longitude);
    Coordinate coorduser =
        Coordinate(latitude: pos.latitude, longitude: pos.longitude);
    //Hacer el calculo
    var distance = 0.0;
    var distanceInMeters = await Geolocator.distanceBetween(
      coordEvent.latitude,
      coordEvent.longitude,
      coorduser.latitude,
      coorduser.longitude,
    );

    distance = distanceInMeters;

    return distance;
  }
}
