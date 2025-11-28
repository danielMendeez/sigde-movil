import 'package:flutter/foundation.dart';
import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/models/carta_aceptacion/registrar_carta_aceptacion_request.dart';
import 'package:sigde/services/carta_aceptacion/carta_aceptacion_service.dart';
import 'package:sigde/services/api_client.dart'; // 👈 Asegúrate de importar ApiException
import 'dart:io';

class RegistrarCartaAceptacionViewModel with ChangeNotifier {
  final CartaAceptacionService _cartaAceptacionService;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;
  CartaAceptacion? _cartaAceptacionRegistrada;
  Map<String, List<String>> _validationErrors = {};

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get success => _success;
  CartaAceptacion? get cartaAceptacionRegistrada => _cartaAceptacionRegistrada;
  Map<String, List<String>> get validationErrors => _validationErrors;

  // Método útil para obtener el primer error de un campo específico
  String? getFieldError(String fieldName) {
    if (_validationErrors.containsKey(fieldName) &&
        _validationErrors[fieldName]!.isNotEmpty) {
      return _validationErrors[fieldName]!.first;
    }
    return null;
  }

  // Método para verificar si un campo tiene errores
  bool hasFieldError(String fieldName) {
    return _validationErrors.containsKey(fieldName) &&
        _validationErrors[fieldName]!.isNotEmpty;
  }

  RegistrarCartaAceptacionViewModel(this._cartaAceptacionService);

  Future<bool> registrarCartaAceptacion(
    RegistrarCartaAceptacionRequest request,
    String token,
    File? archivo, // 👈 Nuevo parámetro
  ) async {
    _isLoading = true;
    _success = false;
    _errorMessage = '';
    _cartaAceptacionRegistrada = null;
    _validationErrors = {};
    notifyListeners();

    try {
      _cartaAceptacionRegistrada = await _cartaAceptacionService
          .registrarCartaAceptacion(
            request,
            token,
            archivo,
          ); // 👈 Pasar el archivo
      print(
        'Carta de aceptación registrada: ${_cartaAceptacionRegistrada?.toJson()}',
      );
      _success = true;
      return true;
    } on ApiException catch (e) {
      print('Error API al registrar carta de aceptación: $e');
      _errorMessage = e.message;

      // Extraer errores de validación del ApiException
      if (e.errors != null) {
        _validationErrors = e.errors!.map(
          (key, value) =>
              MapEntry(key, List<String>.from(value.map((e) => e.toString()))),
        );
      }

      // Log detallado para debugging
      print('Error message: $_errorMessage');
      print('Validation errors: $_validationErrors');
      return false;
    } catch (e) {
      print('Error inesperado al registrar carta de aceptación: $e');
      _errorMessage = 'Error inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = '';
    _success = false;
    _cartaAceptacionRegistrada = null;
    _validationErrors = {};
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    _validationErrors = {};
    notifyListeners();
  }

  // Método específico para limpiar errores de validación de un campo
  void limpiarErrorCampo(String fieldName) {
    if (_validationErrors.containsKey(fieldName)) {
      _validationErrors.remove(fieldName);
      notifyListeners();
    }
  }
}
