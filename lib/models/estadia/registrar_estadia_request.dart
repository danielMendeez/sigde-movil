class RegistrarEstadiaRequest {
  final int alumnoId;
  final int empresaId;
  final int carreraId;
  final int tutorId;
  final String asesorExterno;
  final String proyectoNombre;
  final int apoyo;

  RegistrarEstadiaRequest({
    required this.alumnoId,
    required this.empresaId,
    required this.carreraId,
    required this.tutorId,
    required this.asesorExterno,
    required this.proyectoNombre,
    required this.apoyo,
  });

  Map<String, dynamic> toJson() {
    return {
      'alumno_id': alumnoId,
      'empresa_id': empresaId,
      'carrera_id': carreraId,
      'tutor_id': tutorId,
      'asesor_externo': asesorExterno,
      'proyecto_nombre': proyectoNombre,
      'apoyo': apoyo,
    };
  }
}
