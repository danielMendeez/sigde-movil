import 'package:flutter/material.dart';
import 'package:sigde/services/auth/secure_storage_service.dart';
import 'package:sigde/services/auth/biometric_auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsViewModel extends ChangeNotifier {
  bool isBiometricEnabled = false;
  bool isLoading = false;

  SettingsViewModel() {
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    try {
      isBiometricEnabled = await SecureStorageService.isBiometricEnabled();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error leyendo configuración biométrica",
        toastLength: Toast.LENGTH_LONG,
      );
    }
    notifyListeners();
  }

  Future<void> toggleBiometric(bool value) async {
    try {
      isLoading = true;
      notifyListeners();

      final available = await BiometricAuthService.isBiometricAvailable();

      // Activando biometría
      if (value) {
        if (!available) {
          Fluttertoast.showToast(
            msg: "Este dispositivo no soporta autenticación biométrica",
            toastLength: Toast.LENGTH_LONG,
          );
          return;
        }

        // Solicitar autenticación antes de habilitar
        final authenticated = await BiometricAuthService.authenticateUser();

        if (!authenticated) {
          Fluttertoast.showToast(
            msg: "No se pudo activar la autenticación biométrica",
            toastLength: Toast.LENGTH_LONG,
          );
          return;
        }
      }

      // Guardar cambio
      isBiometricEnabled = value;
      await SecureStorageService.setBiometricEnabled(value);

      Fluttertoast.showToast(
        msg: value
            ? "Autenticación biométrica activada"
            : "Autenticación biométrica desactivada",
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Ocurrió un error: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
