class ActualizarEstadiaRequest {
  final String token;
  final int id;
  final int alumnoId;
  final int empresaId;
  final int carreraId;
  final int tutorId;
  final String asesorExterno;
  final String proyectoNombre;
  final int duracionSemanas;
  final int apoyo;
  final String estatus;

  ActualizarEstadiaRequest({
    required this.token,
    required this.id,
    required this.alumnoId,
    required this.empresaId,
    required this.carreraId,
    required this.tutorId,
    required this.asesorExterno,
    required this.proyectoNombre,
    required this.duracionSemanas,
    required this.apoyo,
    required this.estatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
      'alumno_id': alumnoId,
      'carrera_id': carreraId,
      'tutor_id': tutorId,
      'empresa_id': empresaId,
      'asesor_externo': asesorExterno,
      'proyecto_nombre': proyectoNombre,
      'duracion_semanas': duracionSemanas,
      'apoyo': apoyo,
      'estatus': estatus,
    };
  }
}
