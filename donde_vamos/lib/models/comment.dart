class Comment {
  int comentario_evento_id = 0;
  int comentario_evento_evento_id = 0;
  int comentario_evento_calificacion = 0;
  String comentario_evento_texto = '';
  DateTime comentario_evento_fechayhora = DateTime.now();
  String comentario_evento_usuario = '';

  Comment(
      {required this.comentario_evento_evento_id,
      required this.comentario_evento_id,
      required this.comentario_evento_calificacion,
      required this.comentario_evento_fechayhora,
      required this.comentario_evento_texto,
      required this.comentario_evento_usuario});

  Comment.fromJSON(Map<String, dynamic> json) {
    comentario_evento_id = json["comentario_evento_id"];
    comentario_evento_calificacion = json["comentario_evento_calificacion"];
    comentario_evento_evento_id = json["comentario_evento_evento_id"];
    comentario_evento_fechayhora =
        DateTime.parse(json["comentario_evento_fechayhora"]);
    comentario_evento_texto = json["comentario_evento_texto"];
    comentario_evento_usuario = json["comentario_evento_usuario"];
  }

  Map<String, dynamic> toMap() {
    return {
      //'fecha_evento_id': fecha_evento_id,
      'comentario_evento_evento_id': comentario_evento_evento_id,
      'comentario_evento_calificacion': comentario_evento_calificacion,
      'comentario_evento_fechayhora': comentario_evento_fechayhora,
      'comentario_evento_usuario': comentario_evento_usuario,
    };
  }
}
