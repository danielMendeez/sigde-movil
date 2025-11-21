class ListarEstadiasRequest {
  final String token;

  ListarEstadiasRequest({required this.token});
  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
