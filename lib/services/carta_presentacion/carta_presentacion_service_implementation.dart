import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/listar_cartas_presentacion_request.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';

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
  Future<List<CartaPresentacion>> listarCartasPresentacion(
    ListarCartasPresentacionRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/cartaPres/listaCartasPres',
        data: request.toJson(),
      );

      if (response.containsKey('cartasPres') &&
          response['cartasPres'] is List) {
        final List<dynamic> cartasJson = response['cartasPres'];

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
}
