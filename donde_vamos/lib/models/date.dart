class DateEvent {
  int fecha_evento_id;
  int fecha_evento_id_evento;
  String fecha_evento_dia;
  String fecha_evento_horario_inicio;
  String fecha_evento_horario_fin;

  DateEvent(
      {required this.fecha_evento_id,
      required this.fecha_evento_id_evento,
      required this.fecha_evento_dia,
      required this.fecha_evento_horario_fin,
      required this.fecha_evento_horario_inicio});

  DateEvent.fromJSON(Map<String, dynamic> json)
      : fecha_evento_id = json["fecha_evento_id"],
        fecha_evento_id_evento = json["fecha_evento_id_evento"],
        fecha_evento_dia = json["fecha_evento_dia"],
        fecha_evento_horario_inicio = json["fecha_evento_horario_inicio"],
        fecha_evento_horario_fin = json["fecha_evento_horario_fin"];

  Map<String, dynamic> toMap() {
    return {
      //'fecha_evento_id': fecha_evento_id,
      'fecha_evento_id_evento': fecha_evento_id_evento,
      'fecha_evento_dia': fecha_evento_dia,
      'fecha_evento_horario_inicio': fecha_evento_horario_inicio,
      'fecha_evento_horario_fin': fecha_evento_horario_fin,
    };
  }
}
