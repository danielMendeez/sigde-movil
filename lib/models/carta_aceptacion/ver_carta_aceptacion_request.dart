class VerCartaAceptacionRequest {
  final int id;

  VerCartaAceptacionRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
