import 'package:flutter/foundation.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/services/auth/secure_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;
  bool _biometricEnabled = false;
  bool _biometricAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _currentUser != null;
  bool get biometricEnabled => _biometricEnabled;
  bool get biometricAuthenticated => _biometricAuthenticated;

  Future<void> initialize() async {
    try {
      final hasToken = await SecureStorageService.hasToken();

      if (hasToken) {
        _currentUser = await SecureStorageService.getUser();
      }

      _biometricEnabled = await SecureStorageService.isBiometricEnabled();
      // al iniciar, la sesión NO ha pasado biometría todavía
      _biometricAuthenticated = false;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setUser(User user) async {
    _currentUser = user;
    await SecureStorageService.saveUser(user);
    _biometricAuthenticated = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _biometricAuthenticated = false;
    _biometricEnabled = false;
    await SecureStorageService.deleteAll();
    notifyListeners();
  }

  Future<void> loadBiometricPreference() async {
    _biometricEnabled = await SecureStorageService.isBiometricEnabled();
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _biometricEnabled = enabled;
    await SecureStorageService.setBiometricEnabled(enabled);
    notifyListeners();
  }

  // controlar la bandera de sesión
  void setBiometricAuthenticated(bool authenticated) {
    _biometricAuthenticated = authenticated;
    notifyListeners();
  }
}
