class FirmarCartaPresentacionRequest {
  final int id;

  FirmarCartaPresentacionRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
