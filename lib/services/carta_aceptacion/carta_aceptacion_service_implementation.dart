import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/services/api_client.dart';
import 'carta_aceptacion_service.dart';
import 'package:sigde/models/carta_aceptacion/ver_carta_aceptacion_request.dart';

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

  @override
  Future<CartaAceptacion> verCartaAceptacion(
    VerCartaAceptacionRequest request,
    String token,
  ) async {
    try {
      final response = await _apiClient.post(
        '/cartaAcep/verCarta',
        data: request.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('carta')) {
        final cartaData = response['carta'];
        if (cartaData is Map<String, dynamic>) {
          return CartaAceptacion.fromJson(cartaData);
        } else {
          throw CartaAceptacionException('Formato inválido para "carta"');
        }
      } else {
        throw CartaAceptacionException('Respuesta no contiene "carta"');
      }
    } catch (e) {
      throw CartaAceptacionException(
        'Error al obtener carta de aceptación: ${e.toString()}',
      );
    }
  }
}
