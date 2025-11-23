import 'package:flutter/foundation.dart';
import 'package:sigde/models/estadia/eliminar_estadia_request.dart';
import 'package:sigde/services/estadia/estadia_service.dart';

class EliminarEstadiaViewModel with ChangeNotifier {
  final EstadiaService _estadiaService;

  bool _isLoading = false;
  String _errorMessage = '';
  bool _success = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get success => _success;

  EliminarEstadiaViewModel(this._estadiaService);

  Future<bool> eliminarEstadia(String token, int estadiaId) async {
    _isLoading = true;
    _success = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final request = EliminarEstadiaRequest(token: token, id: estadiaId);
      await _estadiaService.eliminarEstadia(request);
      _success = true;
      return true;
    } catch (e) {
      if (e.toString().contains('respuesta inválida') ||
          e.toString().contains('Formato de respuesta')) {
        _success = true;
        return true;
      } else {
        _errorMessage = e.toString();
        return false;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = '';
    _success = false;
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }
}
