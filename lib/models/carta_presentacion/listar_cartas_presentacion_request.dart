class ListarCartasPresentacionRequest {
  final String token;

  ListarCartasPresentacionRequest({required this.token});
  Map<String, dynamic> toJson() {
    return {'token': token};
  }
}
