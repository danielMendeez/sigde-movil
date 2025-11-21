import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigde/models/user.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';
  static const _keyUser = 'user_data';
  static const _keyBiometricEnabled = 'biometric_enabled';

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Guardar usuario
  static Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _keyUser, value: userJson);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Obtener usuario
  static Future<User?> getUser() async {
    final jsonString = await _storage.read(key: _keyUser);
    if (jsonString == null) {
      return null;
    }
    try {
      final userData = jsonDecode(jsonString);
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // Verificar si hay token
  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _keyToken);
    return token != null && token.isNotEmpty;
  }

  // Verificar si hay datos de usuario
  static Future<bool> hasDataUser() async {
    final user = await _storage.read(key: _keyUser);
    return user != null;
  }

  // Eliminar token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Guardar si el usuario activó biometría
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  // Leer si el usuario ha activado biometría
  static Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  // Eliminar todos los datos almacenados
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
