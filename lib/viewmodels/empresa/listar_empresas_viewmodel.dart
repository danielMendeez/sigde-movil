import 'package:flutter/foundation.dart';
import 'package:sigde/models/empresa/empresa.dart';
import 'package:sigde/services/empresa/empresa_service.dart';

class ListarEmpresasViewModel with ChangeNotifier {
  final EmpresaService _empresaService;

  List<Empresa> _empresas = [];
  Empresa? empresaSeleccionado;
  bool _isLoading = false;
  String _errorMessage = '';

  List<Empresa> get empresas => _empresas;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarEmpresasViewModel(this._empresaService);

  Future<void> cargarEmpresas(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _empresas = await _empresaService.listarEmpresas(token);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _empresas = [];
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
    _empresas = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void eliminarEmpresaLocal(int index) {
    if (index >= 0 && index < _empresas.length) {
      _empresas.removeAt(index);
      notifyListeners();
    }
  }

  void actualizarEmpresaLocal(int index, Empresa empresaActualizado) {
    if (index >= 0 && index < _empresas.length) {
      _empresas[index] = empresaActualizado;
      notifyListeners();
    }
  }

  void seleccionarEmpresa(Empresa? empresa) {
    empresaSeleccionado = empresa;
    notifyListeners();
  }

  int? get selectedUserId => empresaSeleccionado?.id;
}
