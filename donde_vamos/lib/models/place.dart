class Place {
  int? lugar_id = 0;
  String? lugar_nombre = '';

  String? lugar_calle = '';

  int? lugar_numero = 0;
  int? numero = 0;

  String? lugar_email = '';

  String? lugar_desc_corta = '';

  String? lugar_desc_larga = '';
  dynamic? lugar_tipo_gastronomico;
  String? lugar_calificacion = '';
  String? lugar_link = '';
  String? lugar_usuario = '';
  String? lugar_coordenadas = '';
  String? lugar_telefono = '';
  int? lugar_tipo_lugar = 0;
  int? lugar_localidad = 0;
  String? localidad_nombre = '';
  String? localidad_provincia = '';
  String? tipo_lugar = '';
  Place(
      {required this.lugar_nombre,
      required this.lugar_calle,
      required this.lugar_numero,
      required this.tipo_lugar,
      required this.localidad_provincia,
      required this.localidad_nombre,
      required this.lugar_usuario,
      required this.lugar_email,
      required this.lugar_desc_corta,
      required this.lugar_desc_larga,
      required this.lugar_tipo_gastronomico,
      required this.lugar_calificacion,
      required this.lugar_link,
      required this.lugar_coordenadas,
      required this.lugar_telefono,
      required this.lugar_tipo_lugar,
      required this.lugar_localidad});
  Map<String, dynamic> toJSON(
      String idLugar,
      String nombreLugar,
      String calleLugar,
      int nro,
      String tipolugar,
      String provincia,
      String localidad,
      String usuario,
      String email,
      String desccorta,
      String desclarga,
      dynamic lugar_tipo_gastronomico,
      String url,
      String telefono) {
    return <String, dynamic>{
      'lugar_id': idLugar,
      'lugar_nombre': nombreLugar,
      'lugar_calle': calleLugar,
      'lugar_numero': nro,
      'tipo_lugar': tipolugar,
      'localidad_provincia': provincia,
      'localidad_nombre': localidad,
      'lugar_email': email,
      'lugar_usuario': usuario,
      'lugar_des_corta': desccorta,
      'lugar_desc_larga': desclarga,
      'lugar_tipo_gastronomico': lugar_tipo_gastronomico,
      'lugar_calificacion': lugar_calificacion,
      'lugar_link': url,
      'lugar_telefono': telefono,
      'lugar_tipo_lugar': lugar_tipo_lugar,
      'lugar_localidad': lugar_localidad,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'lugar_id': lugar_id,
      'lugar_nombre': lugar_nombre,
      'lugar_calle': lugar_calle,
      'lugar_numero': lugar_numero,
      'tipo_lugar': tipo_lugar,
      'localidad_provincia': localidad_provincia,
      'localidad_nombre': lugar_localidad,
      'lugar_email': lugar_email,
      'lugar_usuario': lugar_usuario,
      'lugar_des_corta': lugar_desc_corta,
      'lugar_desc_larga': lugar_desc_larga,
      'lugar_tipo_gastronomico': lugar_tipo_gastronomico,
      'lugar_calificacion': lugar_calificacion,
      'lugar_link': lugar_link,
      'lugar_telefono': lugar_telefono,
      'lugar_tipo_lugar': lugar_tipo_lugar,
      'lugar_localidad': lugar_localidad,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      'lugar_nombre': lugar_nombre,
      'lugar_calle': lugar_calle,
      'lugar_numero': lugar_numero,
      'tipo_lugar': tipo_lugar,
      'localidad_provincia': localidad_provincia,
      'localidad_nombre': lugar_localidad,
      'lugar_email': lugar_email,
      'lugar_usuario': lugar_usuario,
      'lugar_des_corta': lugar_desc_corta,
      'lugar_desc_larga': lugar_desc_larga,
      'lugar_tipo_gastronomico': lugar_tipo_gastronomico,
      'lugar_calificacion': lugar_calificacion,
      'lugar_link': lugar_link,
      'lugar_telefono': lugar_telefono,
      'lugar_tipo_lugar': lugar_tipo_lugar,
      'lugar_localidad': lugar_localidad,
    };
  }

  Place.fromJSON(Map<String, dynamic> json)
      : lugar_id = json["lugar_id"],
        lugar_nombre = json["lugar_nombre"],
        lugar_calle = json['lugar_calle'],
        lugar_numero = json['lugar_numero'],
        localidad_nombre = json["localidad_nombre"],
        localidad_provincia = json["localidad_provincia"],
        numero = json["lugar_numero"],
        lugar_email = json["lugar_email"],
        lugar_desc_corta = json["lugar_des_corta"],
        lugar_desc_larga = json["lugar_desc_larga"],
        lugar_calificacion = json["lugar_calificacion"].toString(),
        lugar_link = json["lugar_link"],
        lugar_coordenadas = json["lugar_coordenadas"].toString(),
        lugar_telefono = json["lugar_telefono"],
        lugar_tipo_gastronomico = json["lugar_tipo_gastronomico"],
        tipo_lugar = json["tipo_lugar_descripcion"],
        lugar_usuario =
            json["lugar_usuario"] == null ? '-' : json["lugar_usuario"];
}
