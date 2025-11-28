import 'carrera_service.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/models/carrera/carrera.dart';

class CarreraException implements Exception {
  final String message;
  CarreraException(this.message);

  @override
  String toString() => 'CarreraException: $message';
}

class CarreraServiceImplementation implements CarreraService {
  final ApiClient _apiClient;

  CarreraServiceImplementation(this._apiClient);

  @override
  Future<List<Carrera>> listarCarreras(String token) async {
    try {
      final response = await _apiClient.post(
        '/carrera/lista',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('carreras') && response['carreras'] is List) {
        final List<dynamic> carrerasJson = response['carreras'];

        final carreras = carrerasJson.map((json) {
          return Carrera.fromJson(json);
        }).toList();

        return carreras;
      } else {
        throw CarreraException(
          'Formato de respuesta inválido: no se encontró el array "carreras"',
        );
      }
    } catch (e) {
      throw CarreraException('Error al listar carreras: ${e.toString()}');
    }
  }
}
