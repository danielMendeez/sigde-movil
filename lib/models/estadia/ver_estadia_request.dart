class VerEstadiaRequest {
  final int id;

  VerEstadiaRequest({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
