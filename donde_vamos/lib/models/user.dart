class User {
  String usuario_id;
  dynamic usuario_contrasenia;
  String usuario_email;
  String usuario_nombre;
  String usuario_apellido;
  String usuario_tipo;
  dynamic empresa_cuil;

  User({
    required this.usuario_id,
    required this.usuario_contrasenia,
    required this.usuario_email,
    required this.usuario_apellido,
    required this.usuario_nombre,
    required this.usuario_tipo,
    required this.empresa_cuil,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario_id': usuario_id,
      'usuario_contraseña': usuario_contrasenia,
      'usuario_email': usuario_email,
      'usuario_nombre': usuario_nombre,
      'usuario_apellido': usuario_apellido,
      'usuario_tipo': 's',
      'empresa_cuil': null,
      //'empresa_nombre': '-',
    };
  }

  User.fromJSON(Map<String, dynamic> json)
      : usuario_id = json["usuario_id"],
        usuario_contrasenia = json["usuario_contraseña"],
        usuario_email = json["usuario_email"],
        usuario_nombre = json["usuario_nombre"],
        usuario_apellido = json["usuario_apellido"],
        usuario_tipo =
            json["usuario_tipo"] == null ? "s" : json["usuario_tipo"],
        empresa_cuil = json["empresa_cuil"];
}
