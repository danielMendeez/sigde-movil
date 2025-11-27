class RegistrarCartaPresentacionRequest {
  final int estadiaId;
  final int tutorId;

  RegistrarCartaPresentacionRequest({
    required this.estadiaId,
    required this.tutorId,
  });

  Map<String, dynamic> toJson() {
    return {'estadia_id': estadiaId, 'tutor_id': tutorId};
  }
}
