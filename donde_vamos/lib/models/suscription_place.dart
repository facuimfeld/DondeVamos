class SuscriptionPlace {
  int suscribe_lugar_id = 0;
  String usuario = '';
  int lugar = 0;

  SuscriptionPlace(
      {required this.suscribe_lugar_id,
      required this.usuario,
      required this.lugar});

  SuscriptionPlace.fromJSON(Map<String, dynamic> json) {
    suscribe_lugar_id = json["suscribe_lugar_id"];
    lugar = json["lugar"];
    usuario = json["usuario"];
  }
}
