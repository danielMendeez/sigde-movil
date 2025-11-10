import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';
  static const _keyUser = 'user_data';

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Guardar usuario
  static Future<void> saveUser(Object user) async {
    await _storage.write(key: _keyUser, value: user.toString());
  }

  // Obtener usuario
  static Future<Object?> getUser() async {
    return await _storage.read(key: _keyUser);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Eliminar token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Eliminar todos los datos almacenados
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
