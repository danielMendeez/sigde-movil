class RegisterRequest {
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String curp;
  final String correo;
  final String telefono;
  final String tipoUsuario;
  final String password;

  RegisterRequest({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.curp,
    required this.correo,
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
      'correo': correo,
      'telefono': telefono,
      'tipo_usuario': tipoUsuario,
      'password': password,
    };
  }
}
