class HourPlace {
  int horarios_lugar_id;
  int horarios_lugar_id_lugar;
  dynamic horarios_lugar_diadesem;
  dynamic horarios_lugar_desde_m;
  dynamic horarios_lugar_hasta_m;
  dynamic horarios_lugar_desde_t;
  dynamic horarios_lugar_hasta_t;
  dynamic horarios_lugar_fecha_desde;
  dynamic horarios_lugar_fecha_hasta;

  HourPlace(
      {required this.horarios_lugar_id_lugar,
      required this.horarios_lugar_id,
      required this.horarios_lugar_diadesem,
      required this.horarios_lugar_desde_m,
      required this.horarios_lugar_hasta_m,
      required this.horarios_lugar_desde_t,
      required this.horarios_lugar_fecha_desde,
      required this.horarios_lugar_fecha_hasta,
      required this.horarios_lugar_hasta_t});

  HourPlace.fromJSON(Map<String, dynamic> json)
      : horarios_lugar_id = json["horarios_lugar_id"],
        horarios_lugar_id_lugar = json["horarios_lugar_id_lugar"],
        horarios_lugar_diadesem = json["horarios_lugar_diadesem"],
        horarios_lugar_desde_m = json["horarios_lugar_desde_m"],
        horarios_lugar_hasta_m = json["horarios_lugar_hasta_m"],
        horarios_lugar_desde_t = json["horarios_lugar_desde_t"],
        horarios_lugar_hasta_t = json["horarios_lugar_hasta_t"],
        horarios_lugar_fecha_desde = json["horarios_lugar_fecha_desde"],
        horarios_lugar_fecha_hasta = json["horarios_lugar_fecha_hasta"];
}
