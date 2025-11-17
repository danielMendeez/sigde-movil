import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../services/auth/secure_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _currentUser != null;

  Future<void> initialize() async {
    try {
      final hasToken = await SecureStorageService.hasToken();
      if (hasToken) {
        _currentUser = await SecureStorageService.getUser();
      }
    } catch (e) {
      // Handle errors if necessary
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
}
