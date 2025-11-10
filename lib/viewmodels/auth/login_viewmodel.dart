import 'package:flutter/foundation.dart';
import '../../models/auth/login_request.dart';
import '../../models/user.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/secure_storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<User?> login(String correo, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loginRequest = LoginRequest(correo: correo, password: password);
      final user = await _authService.login(loginRequest);

      if (user != null) {
        // Guardar token de sesión
        await SecureStorageService.saveToken(user.token);
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
