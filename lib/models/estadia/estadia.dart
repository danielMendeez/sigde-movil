class Estadia {
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

  Estadia({
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
  });

  // Crear objeto desde JSON
  factory Estadia.fromJson(Map<String, dynamic> json) {
    return Estadia(
      alumnoId: json['alumno_id'],
      idDocente: json['id_docente'],
      empresaId: json['empresa_id'],
      asesorExterno: json['asesor_externo'],
      proyectoNombre: json['proyecto_nombre'],
      duracionSemanas: json['duracion_semanas'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      apoyo: json['apoyo'],
      estatus: json['estatus'],
    );
  }

  // Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}
