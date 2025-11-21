class VerEstadiaRequest {
  final String token;
  final int id;

  VerEstadiaRequest({required this.token, required this.id});

  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id};
  }
}
