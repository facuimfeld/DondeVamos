class CalificationPlace {
  int comentario_lugar_id = 0;
  String usuario = '';
  int lugar = 0;
  int comentario_lugar_calificacion = 0;
  String comentario_lugar_texto = '';
  String comentario_lugar_fechayhora = '';

  CalificationPlace(
      {required this.comentario_lugar_id,
      required this.usuario,
      required this.lugar,
      required this.comentario_lugar_calificacion,
      required this.comentario_lugar_fechayhora,
      required this.comentario_lugar_texto});

  CalificationPlace.fromJSON(Map<String, dynamic> json) {
    comentario_lugar_id = json["comentario_lugar_lugar_id"];
    usuario = json["comentario_lugar_usuario"];
    lugar = json["comentario_lugar_lugar_id"];
    comentario_lugar_calificacion = json["comentario_lugar_calificacion"];
    comentario_lugar_fechayhora = json["comentario_lugar_fechayhora"];
    comentario_lugar_texto = json["comentario_lugar_texto"];
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'lugar': lugar,
      'comentario_lugar_calificacion': comentario_lugar_calificacion,
      'comentario_lugar_texto': comentario_lugar_texto,
      'comentario_lugar_fechayhora': comentario_lugar_fechayhora,
    };
  }
}
