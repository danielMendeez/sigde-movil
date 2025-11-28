import 'empresa_service.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/models/empresa/empresa.dart';

class EmpresaException implements Exception {
  final String message;
  EmpresaException(this.message);

  @override
  String toString() => 'EmpresaException: $message';
}

class EmpresaServiceImplementation implements EmpresaService {
  final ApiClient _apiClient;

  EmpresaServiceImplementation(this._apiClient);

  @override
  Future<List<Empresa>> listarEmpresas(String token) async {
    try {
      final response = await _apiClient.post(
        '/empresa/lista',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.containsKey('empresas') && response['empresas'] is List) {
        final List<dynamic> empresasJson = response['empresas'];

        final empresas = empresasJson.map((json) {
          return Empresa.fromJson(json);
        }).toList();

        return empresas;
      } else {
        throw EmpresaException(
          'Formato de respuesta inválido: no se encontró el array "empresas"',
        );
      }
    } catch (e) {
      throw EmpresaException('Error al listar empresas: ${e.toString()}');
    }
  }
}
