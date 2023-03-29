class CommentPlace {
  int comentario_lugar_id = 0;
  String comentario_lugar_texto = '';
  int lugar = 0;
  String usuario = '';
  int comentario_lugar_calificacion = 0;
  String comentario_lugar_fechayhora = '';

  CommentPlace(
      {required this.comentario_lugar_texto,
      required this.lugar,
      required this.usuario,
      required this.comentario_lugar_calificacion,
      required this.comentario_lugar_fechayhora});

  CommentPlace.fromJSON(Map<String, dynamic> json) {
    comentario_lugar_id = json["comentario_lugar_id"];
    comentario_lugar_texto = json["comentario_lugar_texto"];
    lugar = json["comentario_lugar_lugar_id"];
    usuario = json["comentario_lugar_usuario"];
    comentario_lugar_fechayhora = json["comentario_lugar_fechayhora"];
    comentario_lugar_calificacion = json["comentario_lugar_calificacion"];
  }
}
