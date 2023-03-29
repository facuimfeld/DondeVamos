class Event {
  int evento_id;
  String evento_nombre;
  String evento_desc_corta;
  String evento_desc_larga;
  String evento_contacto;

  int evento_aforo;
  int evento_esgratis;
  String evento_compra_url;
  String evento_calificacion;
  int evento_esrepetitivo;
  int evento_lugar;
  String evento_usuario;
  int evento_categoria;
  int evento_subcategoria;
  String categoria_evento;
  String subcategoria_evento;
  String evento_estado;

  Event(
      {required this.evento_id,
      required this.evento_nombre,
      required this.evento_desc_corta,
      required this.evento_desc_larga,
      required this.evento_contacto,
      required this.evento_aforo,
      required this.evento_esgratis,
      required this.evento_compra_url,
      required this.evento_calificacion,
      required this.evento_esrepetitivo,
      required this.evento_lugar,
      required this.evento_usuario,
      required this.evento_categoria,
      required this.evento_subcategoria,
      required this.categoria_evento,
      required this.evento_estado,
      required this.subcategoria_evento});

  Map<String, dynamic> toMap() {
    return {
      'evento_id': evento_id,
      'evento_nombre': evento_nombre,
      'evento_desc_corta': evento_desc_corta,
      'evento_desc_larga': evento_desc_larga,
      'evento_contacto': evento_contacto,
      'evento_aforo': evento_aforo,
      'evento_esgratis': evento_esgratis,
      'evento_compra_url': evento_compra_url,
      'evento_calificacion': evento_calificacion,
      'evento_esrepetitivo': evento_esrepetitivo,
      'evento_lugar': evento_lugar,
      'evento_usuario': evento_usuario,
      'evento_categoria': evento_categoria,
      'evento_subcategoria': evento_subcategoria,
      'categoria_evento': categoria_evento,
      'subcategoria_evento': subcategoria_evento,
      'evento_estado': evento_estado,
    };
  }

  Event.fromJSON(Map<String, dynamic> json)
      : evento_id = json["evento_id"],
        evento_aforo = json["evento_aforo"],
        evento_calificacion = json["evento_calificacion"],
        evento_compra_url = json["evento_compra_url"],
        evento_contacto = json["evento_contacto"],
        evento_desc_corta = json["evento_desc_corta"],
        evento_desc_larga = json["evento_desc_larga"],
        evento_esgratis = json["evento_esgratis"],
        evento_esrepetitivo = json["evento_esrepetitivo"],
        evento_lugar = json["evento_lugar"],
        evento_nombre = json["evento_nombre"],
        evento_usuario = json["evento_usuario"],
        evento_categoria = json["evento_categoria"],
        evento_subcategoria = json["evento_subcategoria"],
        categoria_evento = json["categoria_evento"],
        subcategoria_evento = json["subcategoria_evento"],
        evento_estado = json["evento_estado"];
}
