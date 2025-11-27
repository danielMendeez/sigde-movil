import 'package:flutter/foundation.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/actualizar_estadia_request.dart';
import 'package:sigde/services/estadia/estadia_service.dart';

class ActualizarEstadiaViewModel with ChangeNotifier {
  final EstadiaService _estadiaService;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;
  Estadia? _estadiaActualizada;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get success => _success;
  Estadia? get estadiaActualizada => _estadiaActualizada;

  ActualizarEstadiaViewModel(this._estadiaService);

  Future<bool> actualizarEstadia(
    ActualizarEstadiaRequest request,
    String token,
  ) async {
    _isLoading = true;
    _success = false;
    _errorMessage = '';
    _estadiaActualizada = null;
    notifyListeners();

    try {
      _estadiaActualizada = await _estadiaService.actualizarEstadia(
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
    _estadiaActualizada = null;
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }
}
