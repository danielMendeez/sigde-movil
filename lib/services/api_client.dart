import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiClient {
  late final Dio _dio;

  ApiClient() {
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

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      final response = await _dio.post(path, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      final response = await _dio.put(path, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: headers);
      final response = await _dio.delete(path, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    if (e.response != null) {
      final dynamic responseData = e.response?.data;
      final String message =
          responseData is Map && responseData.containsKey('message')
          ? responseData['message']
          : 'Error del servidor: ${e.response?.statusCode}';

      return ApiException(
        message: message,
        statusCode: e.response?.statusCode ?? 500,
      );
    } else {
      return ApiException(
        message: 'Error de conexión: ${e.message}',
        statusCode: 0,
      );
    }
  }
}
