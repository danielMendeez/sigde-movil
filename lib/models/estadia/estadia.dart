class Estadia {
  final int id;
  final int alumnoId;
  final int idDocente;
  final int empresaId;
  final String asesorExterno;
  final String proyectoNombre;
  final int duracionSemanas;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String apoyo;
  final String estatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Estadia({
    required this.id,
    required this.alumnoId,
    required this.idDocente,
    required this.empresaId,
    required this.asesorExterno,
    required this.proyectoNombre,
    required this.duracionSemanas,
    required this.fechaInicio,
    required this.fechaFin,
    required this.apoyo,
    required this.estatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Estadia.fromJson(Map<String, dynamic> json) {
    return Estadia(
      id: json['id'] ?? 0,
      alumnoId: json['alumno_id'] ?? 0,
      idDocente: json['id_docente'] ?? 0,
      empresaId: json['empresa_id'] ?? 0,
      asesorExterno: json['asesor_externo'] ?? '',
      proyectoNombre: json['proyecto_nombre'] ?? '',
      duracionSemanas: json['duracion_semanas'] ?? 0,
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      apoyo: json['apoyo'] ?? '',
      estatus: json['estatus'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumnoId,
      'id_docente': idDocente,
      'empresa_id': empresaId,
      'asesor_externo': asesorExterno,
      'proyecto_nombre': proyectoNombre,
      'duracion_semanas': duracionSemanas,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'apoyo': apoyo,
      'estatus': estatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
