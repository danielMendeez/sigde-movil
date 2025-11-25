import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/services/api_client.dart';
import 'carta_aceptacion_service.dart';

class CartaAceptacionException implements Exception {
  final String message;
  CartaAceptacionException(this.message);

  @override
  String toString() => 'CartaAceptacionException: $message';
}

class CartaAceptacionServiceImplementation implements CartaAceptacionService {
  final ApiClient _apiClient;

  CartaAceptacionServiceImplementation(this._apiClient);

  @override
  Future<List<CartaAceptacion>> listarCartasAceptacion(String token) async {
    try {
      final response = await _apiClient.post(
        '/cartaAcep/listaCartas',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('cartas') && response['cartas'] is List) {
        final List<dynamic> cartasJson = response['cartas'];
        return cartasJson
            .map((json) => CartaAceptacion.fromJson(json))
            .toList();
      } else {
        throw CartaAceptacionException(
          'Formato de respuesta inválido: no se encontró el array "cartas"',
        );
      }
    } catch (e) {
      throw CartaAceptacionException(
        'Error al listar cartas de aceptación: ${e.toString()}',
      );
    }
  }
}
