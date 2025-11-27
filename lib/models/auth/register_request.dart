class RegisterRequest {
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String curp;
  final String numSeguridadSocial;
  final String correo;
  final String matricula;
  final String telefono;
  final String tipoUsuario;
  final String password;

  RegisterRequest({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.curp,
    required this.numSeguridadSocial,
    required this.correo,
    required this.matricula,
    required this.telefono,
    required this.tipoUsuario,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'curp': curp,
      'Num_seguridad_social': numSeguridadSocial,
      'correo': correo,
      'matricula': matricula,
      'telefono': telefono,
      'tipo_usuario': tipoUsuario,
      'password': password,
    };
  }
}
