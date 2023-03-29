import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class Maps {
  static void openGoogleMaps(String direction) async {
    String query = Uri.encodeComponent(direction);
    List<Location> location = await locationFromAddress(direction);
    String latitude = location[0].latitude.toString();
    String longitude = location[0].longitude.toString();
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openMapWithCoordinates(
      double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  //API KEY Google Maps AlzaSyCbM6g84qSuDrmlwGfva5ErcDPNIpVjq70
}
