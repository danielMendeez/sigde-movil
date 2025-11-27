import 'package:flutter/foundation.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/firmar_carta_presentacion_request.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';

class FirmarCartaPresentacionViewModel with ChangeNotifier {
  final CartaPresentacionService _cartaPresentacionService;

  CartaPresentacion? _cartaPresentacion;
  bool _isLoading = false;
  String _errorMessage = '';

  CartaPresentacion? get cartaPresentacion => _cartaPresentacion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasData => _cartaPresentacion != null;

  FirmarCartaPresentacionViewModel(this._cartaPresentacionService);

  Future<void> firmarCartaPresentacion(
    String token,
    int cartaPresentacionId,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    _cartaPresentacion = null;
    notifyListeners();

    try {
      final request = FirmarCartaPresentacionRequest(id: cartaPresentacionId);
      _cartaPresentacion = await _cartaPresentacionService
          .firmarCartaPresentacion(request, token);
    } catch (e) {
      _errorMessage = e.toString();
      _cartaPresentacion = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  void limpiarDatos() {
    _cartaPresentacion = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void actualizarCartaPresentacion(
    CartaPresentacion cartaPresentacionActualizada,
  ) {
    _cartaPresentacion = cartaPresentacionActualizada;
    notifyListeners();
  }
}
