import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;
  final dynamic responseData;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
    this.responseData,
  });

  String? getFirstError(String fieldName) {
    if (errors != null && errors![fieldName] is List) {
      final fieldErrors = errors![fieldName] as List;
      if (fieldErrors.isNotEmpty) {
        return fieldErrors.first.toString();
      }
    }
    return null;
  }

  List<String> getFieldErrors(String fieldName) {
    if (errors != null && errors![fieldName] is List) {
      return (errors![fieldName] as List).map((e) => e.toString()).toList();
    }
    return [];
  }

  bool hasFieldError(String fieldName) {
    return errors != null &&
        errors!.containsKey(fieldName) &&
        (errors![fieldName] as List).isNotEmpty;
  }

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      final errorDetails = errors!.entries
          .map((entry) {
            final field = entry.key;
            final messages = (entry.value as List).join(', ');
            return '$field: $messages';
          })
          .join('\n');
      return 'ApiException: $message (Status: $statusCode)\n$errorDetails';
    }
    return 'ApiException: $message (Status: $statusCode)';
  }
}

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8001/api';

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30), // Aumentado para archivos
        receiveTimeout: const Duration(seconds: 30), // Aumentado para archivos
        headers: {
          'Accept': 'application/json',
          // No establecer 'Content-Type' aquí, se establecerá automáticamente para multipart
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

  // Método POST original para JSON
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final options = Options(
        headers: {'Content-Type': 'application/json', ...?headers},
        responseType: responseType,
      );
      final response = await _dio.post(path, data: data, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // NUEVO MÉTODO PARA SUBIR ARCHIVOS MULTIPART
  Future<dynamic> postMultipart(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, dynamic>? files, // {'campo_archivo': File}
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      // Crear FormData
      final formData = FormData();

      // Agregar campos normales
      fields.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Agregar archivos
      if (files != null) {
        files.forEach((key, value) async {
          if (value != null && value is File) {
            final file = value;
            final fileName = file.path.split('/').last;

            formData.files.add(
              MapEntry(
                key,
                await MultipartFile.fromFile(file.path, filename: fileName),
              ),
            );
          }
        });
      }

      final options = Options(
        headers: {
          // Dio establecerá automáticamente 'Content-Type' para multipart
          ...?headers,
        },
      );

      final response = await _dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // MÉTODO ESPECÍFICO PARA CARTA DE ACEPTACIÓN
  Future<Map<String, dynamic>> postCartaAceptacion(
    String path, {
    required Map<String, dynamic> cartaData,
    File? archivo,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('estadia_id', cartaData['estadia_id'].toString()),
        MapEntry('fecha_recepcion', cartaData['fecha_recepcion']),
        MapEntry('observaciones', cartaData['observaciones']),
      ]);

      if (archivo != null) {
        final fileName = archivo.path.split('/').last;

        formData.files.add(
          MapEntry(
            'ruta_documento',
            await MultipartFile.fromFile(archivo.path, filename: fileName),
          ),
        );
      }

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: {...?headers}),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

      return response.data as Map<String, dynamic>;
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

  // MÉTODO PUT MULTIPART
  Future<dynamic> putMultipart(
    String path, {
    required Map<String, dynamic> fields,
    Map<String, dynamic>? files,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Agregar campos normales
      fields.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Agregar archivos
      if (files != null) {
        files.forEach((key, value) async {
          if (value != null && value is File) {
            final file = value;
            final fileName = file.path.split('/').last;

            formData.files.add(
              MapEntry(
                key,
                await MultipartFile.fromFile(file.path, filename: fileName),
              ),
            );
          }
        });
      }

      final options = Options(headers: headers);

      final response = await _dio.put(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );

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
      final statusCode = e.response?.statusCode ?? 500;

      String message;
      Map<String, dynamic>? errors;

      if (responseData is Map<String, dynamic>) {
        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['mensaje'] ??
            'Error del servidor: $statusCode';

        errors = _extractValidationErrors(responseData);
      } else if (responseData is String) {
        message = responseData;
      } else {
        message = 'Error del servidor: $statusCode';
      }

      return ApiException(
        message: message,
        statusCode: statusCode,
        errors: errors,
        responseData: responseData,
      );
    } else {
      return ApiException(
        message: 'Error de conexión: ${e.message}',
        statusCode: 0,
      );
    }
  }

  Map<String, dynamic>? _extractValidationErrors(
    Map<String, dynamic> responseData,
  ) {
    if (responseData['errors'] is Map) {
      return Map<String, dynamic>.from(responseData['errors']);
    }

    if (responseData['error'] is Map) {
      return Map<String, dynamic>.from(responseData['error']);
    }

    if (responseData['validation_errors'] is Map) {
      return Map<String, dynamic>.from(responseData['validation_errors']);
    }

    if (responseData.containsKey('message') &&
        (responseData['statusCode'] == 422 ||
            responseData.containsKey('errors'))) {
      return Map<String, dynamic>.from(responseData);
    }

    return null;
  }
}
