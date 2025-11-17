import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';
  static const _keyUser = 'user_data';

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Guardar usuario
  static Future<void> saveUser(User user) async {
    final jsonString = jsonEncode(user.toJson());
    try {
      await _storage.write(key: _keyUser, value: jsonString);
      final data = jsonDecode(jsonString);
      print('✅ user_data guardado: $data');
    } catch (e) {
      print('❌ Error al guardar usuario: $e');
      return null;
    }
  }

  // Obtener usuario
  // static Future<User?> getUser() async {
  //   final jsonString = await _storage.read(key: _keyUser);
  //   if (jsonString == null) return null;
  //   try {
  //     final data = jsonDecode(jsonString);
  //     return User.fromJson(data);
  //   } catch (e) {
  //     print('Error al decodificar usuario: $e');
  //     return null;
  //   }
  // }
  static Future<User?> getUser() async {
    final jsonString = await _storage.read(key: _keyUser);
    if (jsonString == null) {
      print('⚠️ user_data está vacío');
      return null;
    }
    try {
      final data = jsonDecode(jsonString);
      print('✅ user_data recuperado: $data');
      return User.fromJson(data);
    } catch (e) {
      print('❌ Error al decodificar usuario: $e');
      return null;
    }
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Verificar si hay token
  static Future<bool> hasToken() async {
    final token = await _storage.read(key: _keyToken);
    return token != null && token.isNotEmpty;
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
