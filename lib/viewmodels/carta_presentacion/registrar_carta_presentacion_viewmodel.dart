import 'package:flutter/foundation.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/registrar_carta_presentacion_request.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';

class RegistrarCartaPresentacionViewModel with ChangeNotifier {
  final CartaPresentacionService _cartaPresentacionService;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;
  CartaPresentacion? _cartaPresentacionRegistrada;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get success => _success;
  CartaPresentacion? get cartaPresentacionRegistrada =>
      _cartaPresentacionRegistrada;

  RegistrarCartaPresentacionViewModel(this._cartaPresentacionService);

  Future<bool> registrarCartaPresentacion(
    RegistrarCartaPresentacionRequest request,
    String token,
  ) async {
    _isLoading = true;
    _success = false;
    _errorMessage = '';
    _cartaPresentacionRegistrada = null;
    notifyListeners();

    try {
      _cartaPresentacionRegistrada = await _cartaPresentacionService
          .registrarCartaPresentacion(request, token);
      print(
        'Carta de presentación registrada: ${_cartaPresentacionRegistrada?.toJson()}',
      );
      _success = true;
      return true;
    } catch (e) {
      print('Error al registrar carta de presentación: $e');
      _errorMessage = e.toString();
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
    _cartaPresentacionRegistrada = null;
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }
}
