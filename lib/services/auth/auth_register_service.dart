import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigde/models/auth/register_request.dart';
import 'package:sigde/models/user/user.dart';

class AuthRegisterService {
  late final Dio _dio;

  AuthRegisterService() {
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

  Future<User?> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/usuarios/registrar',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        // print(response.data);
        return User.fromJson(response.data);
      } else {
        throw Exception(
          'No pudimos registrar tu cuenta. Por favor, verifica tus datos e intenta nuevamente.',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;

        // data puede ser Map o String; procesamos Map para extraer message/errors
        if (data is Map<String, dynamic>) {
          final parts = <String>[];

          if (data.containsKey('message')) {
            final m = data['message'];
            if (m != null) parts.add(m.toString());
          }

          // Laravel-style validation errors normalmente vienen en 'errors'
          if (data.containsKey('errors') && data['errors'] is Map) {
            final errors = data['errors'] as Map<String, dynamic>;
            errors.forEach((key, value) {
              if (value is List) {
                for (var v in value) {
                  parts.add(v.toString());
                }
              } else {
                parts.add(value.toString());
              }
            });
          }

          // Intentar también 'mensaje' por compatibilidad
          if (parts.isEmpty && data.containsKey('mensaje')) {
            final m = data['mensaje'];
            if (m != null) parts.add(m.toString());
          }

          final msg = parts.isNotEmpty
              ? parts.join(' | ')
              : 'Ocurrió un error inesperado. Por favor, intenta más tarde.';

          throw Exception(msg);
        } else {
          // Si la respuesta no es un Map, devolver su representación
          final msg =
              data?.toString() ??
              'Ocurrió un error inesperado. Por favor, intenta más tarde.';
          throw Exception(msg);
        }
      } else {
        throw Exception(
          'No podemos conectarnos con el servidor en este momento. Verifica tu conexión a internet e intenta nuevamente.',
        );
      }
    }
  }
}
