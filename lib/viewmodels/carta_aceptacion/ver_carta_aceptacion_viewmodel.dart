import 'package:flutter/foundation.dart';
import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/models/carta_aceptacion/ver_carta_aceptacion_request.dart';
import 'package:sigde/services/carta_aceptacion/carta_aceptacion_service.dart';

class VerCartaAceptacionViewModel with ChangeNotifier {
  final CartaAceptacionService _cartaAceptacionService;

  CartaAceptacion? _cartaAceptacion;
  bool _isLoading = false;
  String _errorMessage = '';

  CartaAceptacion? get cartaAceptacion => _cartaAceptacion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasData => _cartaAceptacion != null;

  VerCartaAceptacionViewModel(this._cartaAceptacionService);

  Future<void> cargarCartaAceptacion(
    String token,
    int cartaAceptacionId,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    _cartaAceptacion = null;
    notifyListeners();

    try {
      final request = VerCartaAceptacionRequest(id: cartaAceptacionId);
      _cartaAceptacion = await _cartaAceptacionService.verCartaAceptacion(
        request,
        token,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _cartaAceptacion = null;
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
    _cartaAceptacion = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void actualizarCartaAceptacion(CartaAceptacion cartaAceptacionActualizada) {
    _cartaAceptacion = cartaAceptacionActualizada;
    notifyListeners();
  }
}
