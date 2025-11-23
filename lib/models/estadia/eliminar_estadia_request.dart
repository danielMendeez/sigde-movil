class EliminarEstadiaRequest {
  final String token;
  final int id;

  EliminarEstadiaRequest({required this.token, required this.id});
  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id};
  }
}
