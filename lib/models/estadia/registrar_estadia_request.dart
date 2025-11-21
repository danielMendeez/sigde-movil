class RegistrarEstadiaRequest {
  final String token;
  final int alumnoId;
  final int idDocente;
  final int empresaId;
  final String asesorExterno;
  final String proyectoNombre;
  final int duracionSemanas;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String apoyo;

  RegistrarEstadiaRequest({
    required this.token,
    required this.alumnoId,
    required this.idDocente,
    required this.empresaId,
    required this.asesorExterno,
    required this.proyectoNombre,
    required this.duracionSemanas,
    required this.fechaInicio,
    required this.fechaFin,
    required this.apoyo,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'alumno_id': alumnoId,
      'id_docente': idDocente,
      'empresa_id': empresaId,
      'asesor_externo': asesorExterno,
      'proyecto_nombre': proyectoNombre,
      'duracion_semanas': duracionSemanas,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'apoyo': apoyo,
    };
  }
}
