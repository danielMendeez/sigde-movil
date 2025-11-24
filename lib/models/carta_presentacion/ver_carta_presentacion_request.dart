class VerCartaPresentacionRequest {
  final String token;
  final int id;

  VerCartaPresentacionRequest({required this.token, required this.id});

  Map<String, dynamic> toJson() {
    return {'token': token, 'id': id};
  }
}
