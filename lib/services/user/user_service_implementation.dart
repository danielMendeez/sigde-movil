import 'user_service.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/models/user/user.dart';

class UserException implements Exception {
  final String message;
  UserException(this.message);

  @override
  String toString() => 'UserException: $message';
}

class UserServiceImplementation implements UserService {
  final ApiClient _apiClient;

  UserServiceImplementation(this._apiClient);

  @override
  Future<List<User>> listarUsuarios() async {
    try {
      final response = await _apiClient.post('/usuarios/listar');

      if (response.containsKey('usuarios') && response['usuarios'] is List) {
        final List<dynamic> usuariosJson = response['usuarios'];

        final usuarios = usuariosJson.map((json) {
          return User.fromJson(json);
        }).toList();

        return usuarios;
      } else {
        throw UserException(
          'Formato de respuesta inválido: no se encontró el array "usuarios"',
        );
      }
    } catch (e) {
      throw UserException('Error al listar usuarios: ${e.toString()}');
    }
  }
}
