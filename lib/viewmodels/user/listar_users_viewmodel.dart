import 'package:flutter/foundation.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/services/user/user_service.dart';

class ListarUsersViewModel with ChangeNotifier {
  final UserService _userService;

  List<User> _users = [];
  User? alumnoSeleccionado;
  User? tutorSeleccionado;
  bool _isLoading = false;
  String _errorMessage = '';

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;

  ListarUsersViewModel(this._userService);

  Future<void> cargarUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _users = await _userService.listarUsuarios();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _users = [];
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
    _users = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void eliminarUserLocal(int index) {
    if (index >= 0 && index < _users.length) {
      _users.removeAt(index);
      notifyListeners();
    }
  }

  void actualizarUserLocal(int index, User userActualizado) {
    if (index >= 0 && index < _users.length) {
      _users[index] = userActualizado;
      notifyListeners();
    }
  }

  void seleccionarAlumno(User? user) {
    alumnoSeleccionado = user;
    notifyListeners();
  }

  void seleccionarTutor(User? user) {
    tutorSeleccionado = user;
    notifyListeners();
  }

  int? get selectedUserId => alumnoSeleccionado?.id;
}
