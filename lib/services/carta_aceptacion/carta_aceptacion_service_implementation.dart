import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/services/api_client.dart';
import 'carta_aceptacion_service.dart';
import 'package:sigde/models/carta_aceptacion/ver_carta_aceptacion_request.dart';
import 'package:sigde/models/carta_aceptacion/registrar_carta_aceptacion_request.dart';
import 'dart:io';

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
    } on ApiException {
      rethrow;
    } catch (e) {
      throw CartaAceptacionException(
        'Error al obtener carta de aceptación: ${e.toString()}',
      );
    }
  }

  @override
  Future<CartaAceptacion> registrarCartaAceptacion(
    RegistrarCartaAceptacionRequest request,
    String token,
    File? archivo,
  ) async {
    try {
      // Preparar datos para el multipart
      final cartaData = {
        'estadia_id': request.estadiaId,
        'fecha_recepcion': request.fechaRecepcion.toIso8601String(),
        'observaciones': request.observaciones,
      };

      final headers = {'Authorization': 'Bearer $token'};

      // Usar el método específico para carta de aceptación
      final response = await _apiClient.postCartaAceptacion(
        '/cartaAcep/registrar',
        cartaData: cartaData,
        archivo: archivo,
        headers: headers,
        onSendProgress: (sent, total) {
          print('Progreso de subida: $sent/$total');
        },
      );

      if (response is Map<String, dynamic>) {
        return CartaAceptacion.fromJson(response);
      } else {
        throw ApiException(
          message: 'Formato de respuesta inválido',
          statusCode: 0,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Error inesperado: $e', statusCode: 0);
    }
  }
}
