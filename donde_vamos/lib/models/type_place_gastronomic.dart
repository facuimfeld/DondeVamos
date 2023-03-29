class TypePlaceGastronomic {
  int tipo_gastronomico_id;
  String tipo_gastronomico_descripcion;
  TypePlaceGastronomic(
      {required this.tipo_gastronomico_descripcion,
      required this.tipo_gastronomico_id});

  TypePlaceGastronomic.fromJSON(Map<String, dynamic> json)
      : tipo_gastronomico_id = json["tipo_gastronomico_id"],
        tipo_gastronomico_descripcion = json["tipo_gastronomico_descripcion"];
}
