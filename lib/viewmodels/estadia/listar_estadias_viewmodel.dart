import 'package:flutter/foundation.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/services/estadia/estadia_service.dart';

class ListarEstadiasViewModel with ChangeNotifier {
  final EstadiaService _estadiaService;

  List<Estadia> _estadias = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Estadia> get estadias => _estadias;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarEstadiasViewModel(this._estadiaService);

  Future<void> cargarEstadias(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _estadias = await _estadiaService.listarEstadias(token);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _estadias = [];
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
    _estadias = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void eliminarEstadiaLocal(int index) {
    if (index >= 0 && index < _estadias.length) {
      _estadias.removeAt(index);
      notifyListeners();
    }
  }

  void actualizarEstadiaLocal(int index, Estadia estadiaActualizada) {
    if (index >= 0 && index < _estadias.length) {
      _estadias[index] = estadiaActualizada;
      notifyListeners();
    }
  }
}
