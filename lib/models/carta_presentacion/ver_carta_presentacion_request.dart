class VerCartaPresentacionRequest {
  final int id;

  VerCartaPresentacionRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
