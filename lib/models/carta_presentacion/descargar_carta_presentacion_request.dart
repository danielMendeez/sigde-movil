class DescargarCartaPresentacionRequest {
  final int id;

  DescargarCartaPresentacionRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
