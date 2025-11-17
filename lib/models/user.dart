class User {
  final int id;
  final String? nombre;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final String? curp;
  final String? correo;
  final String? telefono;
  final String? tipoUsuario;
  final String token;

  User({
    required this.id,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.curp,
    this.correo,
    this.telefono,
    this.tipoUsuario,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['usuario'] ?? json;

    return User(
      id: userData['id'],
      nombre: userData['nombre'] ?? '',
      apellidoPaterno: userData['apellido_paterno'] ?? '',
      apellidoMaterno: userData['apellido_materno'] ?? '',
      curp: userData['curp'] ?? '',
      correo: userData['correo'] ?? '',
      telefono: userData['telefono'] ?? '',
      tipoUsuario: userData['tipo_usuario'] ?? '',
      token: (userData['token'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellido_paterno': apellidoPaterno,
    'apellido_materno': apellidoMaterno,
    'curp': curp,
    'correo': correo,
    'telefono': telefono,
    'tipo_usuario': tipoUsuario,
    'token': token,
  };
}
