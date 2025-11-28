import 'package:flutter/foundation.dart';
import 'package:sigde/models/carrera/carrera.dart';
import 'package:sigde/services/carrera/carrera_service.dart';

class ListarCarrerasViewModel with ChangeNotifier {
  final CarreraService _carreraService;

  List<Carrera> _carreras = [];
  Carrera? carreraSeleccionada;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Carrera> get carreras => _carreras;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarCarrerasViewModel(this._carreraService);

  /// Cargar carreras desde API
  Future<void> cargarCarreras(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _carreras = await _carreraService.listarCarreras(token);
    } catch (e) {
      _errorMessage = e.toString();
      _carreras = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar errores
  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Limpiar datos completamente
  void limpiarDatos() {
    _carreras = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  /// Eliminar carrera de lista local
  void eliminarCarreraLocal(int index) {
    if (index >= 0 && index < _carreras.length) {
      _carreras.removeAt(index);
      notifyListeners();
    }
  }

  /// Actualizar carrera localmente
  void actualizarCarreraLocal(int index, Carrera carreraActualizada) {
    if (index >= 0 && index < _carreras.length) {
      _carreras[index] = carreraActualizada;
      notifyListeners();
    }
  }

  /// Seleccionar carrera actual para el dropdown
  void seleccionarCarrera(Carrera? carrera) {
    carreraSeleccionada = carrera;
    notifyListeners();
  }

  int? get selectedCarreraId => carreraSeleccionada?.id;
}
