import 'package:url_launcher/url_launcher.dart';

class Email {
  void sendMail(String contactEmail) async {
    String subject = 'Duda Evento';
    String body = 'Hola!, tengo una duda sobre el evento..';
    // Android and iOS
    String uri = 'mailto:$contactEmail?subject=$subject&body=$body';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
