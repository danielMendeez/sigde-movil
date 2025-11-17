import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticateUser() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isAvailable = await _auth.isDeviceSupported();

      if (!canCheck || !isAvailable) {
        print('⚠️ Biometría no disponible en este dispositivo');
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Por favor, autentícate para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      print('✅ Resultado autenticación: $didAuthenticate');
      return didAuthenticate;
    } catch (e) {
      print('❌ Error en autenticación biométrica: $e');
      return false;
    }
  }
}
