import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Eliminar token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
