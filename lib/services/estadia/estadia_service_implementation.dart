import 'estadia_service.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/models/estadia/ver_estadia_request.dart';
import 'package:sigde/models/estadia/actualizar_estadia_request.dart';
import 'package:sigde/models/estadia/eliminar_estadia_request.dart';

class EstadiaException implements Exception {
  final String message;
  EstadiaException(this.message);

  @override
  String toString() => 'EstadiaException: $message';
}

class EstadiaServiceImplementation implements EstadiaService {
  final ApiClient _apiClient;

  EstadiaServiceImplementation(this._apiClient);

  @override
  Future<List<Estadia>> listarEstadias(String token) async {
    try {
      final response = await _apiClient.post(
        '/estadias/listaEstadias',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('estadias') && response['estadias'] is List) {
        final List<dynamic> estadiasJson = response['estadias'];

        final estadias = estadiasJson.map((json) {
          return Estadia.fromJson(json);
        }).toList();

        return estadias;
      } else {
        throw EstadiaException(
          'Formato de respuesta inválido: no se encontró el array "estadias"',
        );
      }
    } catch (e) {
      throw EstadiaException('Error al listar estadías: ${e.toString()}');
    }
  }

  @override
  Future<Estadia> registrarEstadia(
    RegistrarEstadiaRequest request,
    String token,
  ) async {
    try {
      final response = await _apiClient.post(
        '/estadias/registrar',
        data: request.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('data')) {
        return Estadia.fromJson(response['data']);
      } else {
        throw EstadiaException(
          'Formato de respuesta inválido: no se encontró "estadia"',
        );
      }
    } catch (e) {
      throw EstadiaException('Error al registrar estadía: ${e.toString()}');
    }
  }

  @override
  Future<Estadia> verEstadia(VerEstadiaRequest request, String token) async {
    try {
      final response = await _apiClient.post(
        '/estadias/verEstadia',
        data: request.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('estadia')) {
        final estadiaData = response['estadia'];
        if (estadiaData is Map<String, dynamic>) {
          return Estadia.fromJson(estadiaData);
        } else {
          throw EstadiaException('Formato inválido para "estadia"');
        }
      } else {
        throw EstadiaException('Respuesta no contiene "estadia"');
      }
    } catch (e) {
      throw EstadiaException('Error al obtener estadía: ${e.toString()}');
    }
  }

  @override
  Future<Estadia> actualizarEstadia(ActualizarEstadiaRequest request) async {
    try {
      final response = await _apiClient.post(
        '/estadia/update',
        data: request.toJson(),
      );

      if (response.containsKey('estadia')) {
        return Estadia.fromJson(response['estadia']);
      } else {
        throw EstadiaException(
          'Formato de respuesta inválido: no se encontró "estadia"',
        );
      }
    } catch (e) {
      throw EstadiaException('Error al actualizar estadía: ${e.toString()}');
    }
  }

  @override
  Future<void> eliminarEstadia(EliminarEstadiaRequest request) async {
    try {
      final response = await _apiClient.post(
        '/estadia/delete',
        data: request.toJson(),
      );

      final message = response['message']?.toString() ?? '';
      if (message.toLowerCase().contains('éxito') ||
          message.toLowerCase().contains('exito') ||
          message.toLowerCase().contains('eliminada')) {
        return;
      } else {
        throw EstadiaException('Error del servidor: $message');
      }
    } catch (e) {
      throw EstadiaException('Error al eliminar estadía: ${e.toString()}');
    }
  }
}
