import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/login_request.dart';
import '../models/user.dart';

class AuthService {
  late final Dio _dio;

  AuthService() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<User?> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/usuarios/login',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        // print(response.data);
        return User.fromJson(response.data);
      } else {
        throw Exception('No se pudo iniciar sesión.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['mensaje'] ?? 'Error desconocido';
        throw Exception(msg);
      } else {
        throw Exception('Error de conexión con el servidor.');
      }
    }
  }
}
