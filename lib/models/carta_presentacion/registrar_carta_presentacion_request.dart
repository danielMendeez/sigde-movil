class RegistrarCartaPresentacionRequest {
  final int estadiaId;
  final int directorId;

  RegistrarCartaPresentacionRequest({
    required this.estadiaId,
    required this.directorId,
  });

  Map<String, dynamic> toJson() {
    return {'estadia_id': estadiaId, 'director_id': directorId};
  }
}
