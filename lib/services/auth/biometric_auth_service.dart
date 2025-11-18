import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isBiometricAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    return canCheck && supported;
  }

  static Future<bool> authenticateUser() async {
    try {
      final available = await isBiometricAvailable();
      if (!available) return false;

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Autentícate para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      print("Error biometría: $e");
      return false;
    }
  }
}
