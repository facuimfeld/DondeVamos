class HourEvent {
  int horarios_evento_id_evento;
  int horarios_eventos_id;
  dynamic horarios_eventos_diadesem;
  dynamic horarios_eventos_desde_m;
  dynamic horarios_eventos_hasta_m;
  dynamic horarios_eventos_desde_t;
  dynamic horarios_eventos_hasta_t;
  dynamic horarios_eventos_fecha_desde;
  dynamic horarios_eventos_fecha_hasta;

  HourEvent(
      {required this.horarios_evento_id_evento,
      required this.horarios_eventos_id,
      required this.horarios_eventos_diadesem,
      required this.horarios_eventos_desde_m,
      required this.horarios_eventos_hasta_m,
      required this.horarios_eventos_desde_t,
      required this.horarios_eventos_fecha_desde,
      required this.horarios_eventos_fecha_hasta,
      required this.horarios_eventos_hasta_t});

  HourEvent.fromJSON(Map<String, dynamic> json)
      : horarios_eventos_id = json["horarios_eventos_id"],
        horarios_evento_id_evento = json["horarios_evento_id_evento"],
        horarios_eventos_diadesem = json["horarios_eventos_diadesem"],
        horarios_eventos_desde_m = json["horarios_eventos_desde_m"],
        horarios_eventos_hasta_m = json["horarios_eventos_hasta_m"],
        horarios_eventos_desde_t = json["horarios_eventos_desde_t"],
        horarios_eventos_hasta_t = json["horarios_eventos_hasta_t"],
        horarios_eventos_fecha_desde = json["horarios_eventos_fecha_desde"],
        horarios_eventos_fecha_hasta = json["horarios_eventos_fecha_hasta"];

  Map<String, dynamic> toMap() {
    return {
      'horarios_eventos_id': horarios_eventos_id,
      'horarios_evento_id_evento': horarios_evento_id_evento,
      'horarios_eventos_fecha_desde': null,
      'horarios_eventos_fecha_hasta': null,
      'horarios_eventos_diadesem': horarios_eventos_diadesem,
      'horarios_eventos_desde_m':
          horarios_eventos_desde_m == null ? 'null' : horarios_eventos_desde_m,
      'horarios_eventos_hasta_m': horarios_eventos_hasta_m,
      'horarios_eventos_desde_t': horarios_eventos_desde_t,
      'horarios_eventos_hasta_t':
          horarios_eventos_hasta_t == null ? 'null' : horarios_eventos_hasta_t,
    };
  }

  //mapeo para el caso de que quiera modificar horarios de un evento pero agregando mas horarios
  //no modificando uno que ya está

  Map<String, dynamic> toMapNewHour() {
    return {
      //'horarios_eventos_id': horarios_eventos_id,
      'horarios_evento_id_evento': horarios_evento_id_evento,
      'horarios_eventos_fecha_desde': null,
      'horarios_eventos_fecha_hasta': null,
      'horarios_eventos_diadesem': horarios_eventos_diadesem,
      'horarios_eventos_desde_m':
          horarios_eventos_desde_m == null ? 'null' : horarios_eventos_desde_m,
      'horarios_eventos_hasta_m': horarios_eventos_hasta_m,
      'horarios_eventos_desde_t': horarios_eventos_desde_t,
      'horarios_eventos_hasta_t':
          horarios_eventos_hasta_t == null ? 'null' : horarios_eventos_hasta_t,
    };
  }
}
