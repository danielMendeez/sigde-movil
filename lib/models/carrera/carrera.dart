class Carrera {
  final int id;
  final String nombre;
  final String director;

  Carrera({required this.id, required this.nombre, required this.director});

  // Constructor para crear una instancia desde un Map (útil para JSON)
  factory Carrera.fromJson(Map<String, dynamic> json) {
    return Carrera(
      id: json['id'],
      nombre: json['nombre'],
      director: json['director'],
    );
  }

  // Método para convertir la instancia a Map (útil para JSON)
  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'director': director};
  }

  // Método copyWith para crear copias modificadas
  Carrera copyWith({
    int? id,
    String? nombre,
    String? director,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Carrera(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      director: director ?? this.director,
    );
  }
}
