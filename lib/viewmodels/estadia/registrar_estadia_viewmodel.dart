import 'package:flutter/foundation.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/services/estadia/estadia_service.dart';

class RegistrarEstadiaViewModel with ChangeNotifier {
  final EstadiaService _estadiaService;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;
  Estadia? _estadiaRegistrada;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get success => _success;
  Estadia? get estadiaRegistrada => _estadiaRegistrada;

  RegistrarEstadiaViewModel(this._estadiaService);

  Future<bool> registrarEstadia(
    RegistrarEstadiaRequest request,
    String token,
  ) async {
    _isLoading = true;
    _success = false;
    _errorMessage = '';
    _estadiaRegistrada = null;
    notifyListeners();

    try {
      _estadiaRegistrada = await _estadiaService.registrarEstadia(
        request,
        token,
      );
      _success = true;
      return true;
    } catch (e) {
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
    _estadiaRegistrada = null;
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }
}
