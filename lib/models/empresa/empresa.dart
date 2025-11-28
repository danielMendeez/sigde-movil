class Empresa {
  final int id;
  final String nombre;
  final String rfc;
  final String direccion;
  final String telefono;
  final String correo;

  Empresa({
    required this.id,
    required this.nombre,
    required this.rfc,
    required this.direccion,
    required this.telefono,
    required this.correo,
  });

  // Constructor para crear una instancia desde un Map
  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'],
      nombre: json['nombre'],
      rfc: json['rfc'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'rfc': rfc,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
    };
  }

  // Método copyWith para crear copias modificadas
  Empresa copyWith({
    int? id,
    String? nombre,
    String? rfc,
    String? direccion,
    String? telefono,
    String? correo,
  }) {
    return Empresa(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rfc: rfc ?? this.rfc,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
    );
  }
}
