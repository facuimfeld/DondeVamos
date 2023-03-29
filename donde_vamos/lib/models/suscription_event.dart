class SuscriptionEvent {
  int suscribe_evento_id = 0;
  String suscribe_evento_usuario = '';
  int suscribe_evento_evento_id = 0;

  SuscriptionEvent(
      {required this.suscribe_evento_evento_id,
      required this.suscribe_evento_id,
      required this.suscribe_evento_usuario});

  SuscriptionEvent.fromJSON(Map<String, dynamic> json) {
    suscribe_evento_id = json["suscribe_evento_id"];
    suscribe_evento_evento_id = json["suscribe_evento_evento_id"];
    suscribe_evento_usuario = json["suscribe_evento_usuario"];
  }
}
