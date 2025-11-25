import 'package:flutter/foundation.dart';
import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/services/carta_aceptacion/carta_aceptacion_service.dart';

class ListarCartasAceptacionViewModel with ChangeNotifier {
  final CartaAceptacionService _cartaAceptacionService;

  List<CartaAceptacion> _cartasAceptacion = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<CartaAceptacion> get cartasAceptacion => _cartasAceptacion;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarCartasAceptacionViewModel(this._cartaAceptacionService);

  Future<void> cargarCartasAceptacion(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _cartasAceptacion = await _cartaAceptacionService.listarCartasAceptacion(
        token,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _cartasAceptacion = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void eliminarCartaLocal(int cartaId) {
    _cartasAceptacion.removeWhere((carta) => carta.id == cartaId);
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  void limpiarDatos() {
    _cartasAceptacion = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
