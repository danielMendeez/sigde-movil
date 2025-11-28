import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';

class DescargarCartaPresentacionViewModel extends ChangeNotifier {
  final CartaPresentacionService _cartaPresentacionService;

  DescargarCartaPresentacionViewModel(this._cartaPresentacionService);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<Uint8List> descargarCartaPresentacion(
    int cartaId,
    String token,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final pdfBytes = await _cartaPresentacionService
          .descargarCartaPresentacion(cartaId, token);

      _isLoading = false;
      notifyListeners();
      return pdfBytes ?? Uint8List(0); // evita null
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return Uint8List(0); // evita null
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
