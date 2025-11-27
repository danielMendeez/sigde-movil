import 'package:flutter/material.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';

class ListarCartasPresentacionViewModel with ChangeNotifier {
  final CartaPresentacionService _cartaPresentacionService;

  List<CartaPresentacion> _cartasPresentacion = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<CartaPresentacion> get cartasPresentacion => _cartasPresentacion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarCartasPresentacionViewModel(this._cartaPresentacionService);

  Future<void> cargarCartasPresentacion(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _cartasPresentacion = await _cartaPresentacionService
          .listarCartasPresentacion(token);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _cartasPresentacion = [];
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
    _cartasPresentacion = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void eliminarCartaPresentacionLocal(int index) {
    if (index >= 0 && index < _cartasPresentacion.length) {
      _cartasPresentacion.removeAt(index);
      notifyListeners();
    }
  }

  void actualizarCartaPresentacionLocal(
    int index,
    CartaPresentacion cartaActualizada,
  ) {
    if (index >= 0 && index < _cartasPresentacion.length) {
      _cartasPresentacion[index] = cartaActualizada;
      notifyListeners();
    }
  }
}
