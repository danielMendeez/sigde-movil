import 'package:flutter/foundation.dart';
import '../../models/auth/login_request.dart';
import '../../models/user.dart';
import '../../services/auth/auth_login_service.dart';
import '../../services/auth/secure_storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthLoginService _authLoginService = AuthLoginService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _correoError;
  String? _passwordError;

  // Getters para los estados
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get correoError => _correoError;
  String? get passwordError => _passwordError;

  // Métodos para limpiar errores específicos
  void clearCorreoError() {
    _correoError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  void clearAllErrors() {
    _errorMessage = null;
    _correoError = null;
    _passwordError = null;
    notifyListeners();
  }

  // Validación del formulario
  bool validateForm(String correo, String password) {
    _correoError = null;
    _passwordError = null;

    bool isValid = true;

    // Validar correo
    if (correo.isEmpty) {
      _correoError = 'Por favor ingresa tu correo electrónico';
      isValid = false;
    } else if (!_isValidEmail(correo)) {
      _correoError = 'Por favor ingresa un correo electrónico válido';
      isValid = false;
    }

    // Validar contraseña
    if (password.isEmpty) {
      _passwordError = 'Por favor ingresa tu contraseña';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = 'La contraseña debe tener al menos 6 caracteres';
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<User?> login(String correo, String password) async {
    // Primero validar el formulario
    if (!validateForm(correo, password)) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loginRequest = LoginRequest(correo: correo, password: password);
      final user = await _authLoginService.login(loginRequest);

      if (user != null) {
        // Guardar token de sesión
        await SecureStorageService.saveToken(user.token);
        await SecureStorageService.saveUser(user);
      }

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
