import 'package:flutter/foundation.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/ver_estadia_request.dart';
import 'package:sigde/services/estadia/estadia_service.dart';

class VerEstadiaViewModel with ChangeNotifier {
  final EstadiaService _estadiaService;

  Estadia? _estadia;
  bool _isLoading = false;
  String _errorMessage = '';

  Estadia? get estadia => _estadia;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasData => _estadia != null;

  VerEstadiaViewModel(this._estadiaService);

  Future<void> cargarEstadia(String token, int estadiaId) async {
    _isLoading = true;
    _errorMessage = '';
    _estadia = null;
    notifyListeners();

    try {
      final request = VerEstadiaRequest(id: estadiaId);
      _estadia = await _estadiaService.verEstadia(request, token);
    } catch (e) {
      _errorMessage = e.toString();
      _estadia = null;
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
    _estadia = null;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void actualizarEstadia(Estadia estadiaActualizada) {
    _estadia = estadiaActualizada;
    notifyListeners();
  }
}
