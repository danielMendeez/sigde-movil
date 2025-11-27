import 'package:sigde/services/api_client.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/ver_carta_presentacion_request.dart';

class CartaPresentacionException implements Exception {
  final String message;
  CartaPresentacionException(this.message);

  @override
  String toString() => 'CartaPresentacionException: $message';
}

class CartaPresentacionServiceImplementation
    implements CartaPresentacionService {
  final ApiClient _apiClient;

  CartaPresentacionServiceImplementation(this._apiClient);

  @override
  Future<List<CartaPresentacion>> listarCartasPresentacion(String token) async {
    try {
      final response = await _apiClient.post(
        '/carta-pres/listarCartas',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('cartas') && response['cartas'] is List) {
        final List<dynamic> cartasJson = response['cartas'];

        final cartas = cartasJson.map((json) {
          return CartaPresentacion.fromJson(json);
        }).toList();

        return cartas;
      } else {
        throw CartaPresentacionException(
          'Formato de respuesta inválido: no se encontró el array "cartas_presentacion"',
        );
      }
    } catch (e) {
      throw CartaPresentacionException(
        'Error al listar cartas de presentación: ${e.toString()}',
      );
    }
  }

  @override
  Future<CartaPresentacion> verCartaPresentacion(
    VerCartaPresentacionRequest request,
    String token,
  ) async {
    try {
      final response = await _apiClient.post(
        '/carta-pres/verCarta',
        data: request.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('carta')) {
        final cartaData = response['carta'];
        if (cartaData is Map<String, dynamic>) {
          return CartaPresentacion.fromJson(cartaData);
        } else {
          throw CartaPresentacionException('Formato inválido para "carta"');
        }
      } else {
        throw CartaPresentacionException('Respuesta no contiene "carta"');
      }
    } catch (e) {
      throw CartaPresentacionException(
        'Error al obtener carta de presentación: ${e.toString()}',
      );
    }
  }
}
