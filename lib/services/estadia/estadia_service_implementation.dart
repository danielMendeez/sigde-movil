import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/listar_estadias_request.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/services/api_client.dart';
import 'estadia_service.dart';

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
  Future<List<Estadia>> listarEstadias(ListarEstadiasRequest request) async {
    try {
      final response = await _apiClient.post(
        '/estadia/listaEstadias',
        data: request.toJson(),
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
  Future<Estadia> registrarEstadia(RegistrarEstadiaRequest request) async {
    try {
      final response = await _apiClient.post(
        '/estadia/register',
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
      throw EstadiaException('Error al registrar estadía: ${e.toString()}');
    }
  }
}
