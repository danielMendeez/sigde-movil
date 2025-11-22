class ActualizarEstadiaRequest {
  final String token;
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

  ActualizarEstadiaRequest({
    required this.token,
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
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
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
    };
  }
}
