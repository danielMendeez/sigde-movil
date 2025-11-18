import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../services/auth/secure_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;
  bool _biometricEnabled = false;

  User? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _currentUser != null;
  bool get biometricEnabled => _biometricEnabled;

  Future<void> initialize() async {
    try {
      final hasToken = await SecureStorageService.hasToken();

      if (hasToken) {
        _currentUser = await SecureStorageService.getUser();
      }

      _biometricEnabled = await SecureStorageService.isBiometricEnabled();
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> setUser(User user) async {
    _currentUser = user;
    await SecureStorageService.saveUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
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
}
