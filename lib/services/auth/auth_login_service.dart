import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/auth/login_request.dart';
import '../../models/user.dart';

class AuthLoginService {
  late final Dio _dio;

  AuthLoginService() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8001/api';

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
        throw Exception(
          'No pudimos iniciar tu sesión. Por favor, verifica tus credenciales e intenta nuevamente.',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Imprimir todos los detalles del error
        print('=== DIO EXCEPTION DETAILS ===');
        print('Error Type: ${e.type}');
        print('Error Message: ${e.message}');
        print('Status Code: ${e.response?.statusCode}');
        print('Status Message: ${e.response?.statusMessage}');
        print('Request URL: ${e.requestOptions.uri}');
        print('Request Method: ${e.requestOptions.method}');
        print('Response Headers: ${e.response?.headers}');
        print('Response Data: ${e.response?.data}');
        print('=== END ERROR DETAILS ===');

        final msg =
            e.response?.data['mensaje'] ??
            'Ocurrió un error inesperado. Por favor, intenta más tarde.';
        throw Exception(msg);
      } else {
        // Error sin respuesta (conexión, timeout, etc.)
        print('=== DIO EXCEPTION (NO RESPONSE) ===');
        print('Error Type: ${e.type}');
        print('Error Message: ${e.message}');
        print('Request URL: ${e.requestOptions.uri}');
        print('Request Method: ${e.requestOptions.method}');
        print('=== END ERROR DETAILS ===');

        throw Exception(
          'No podemos conectarnos con el servidor en este momento. Verifica tu conexión a internet e intenta nuevamente.',
        );
      }
    }
  }
}
