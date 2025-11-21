import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigde/services/auth/biometric_auth_service.dart';
import 'package:sigde/viewmodels/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class BiometricLockView extends StatefulWidget {
  const BiometricLockView({super.key});

  @override
  State<BiometricLockView> createState() => _BiometricLockViewState();
}

class _BiometricLockViewState extends State<BiometricLockView> {
  @override
  void initState() {
    super.initState();
    _auth();
  }

  Future<void> _auth() async {
    final authViewModel = context.read<AuthViewModel>();
    final ok = await BiometricAuthService.authenticateUser();

    if (!mounted) return;

    if (ok) {
      // marcar que la biometría ya pasó para esta sesión
      authViewModel.setBiometricAuthenticated(true);

      // navegar al dashboard
      context.go('/dashboard');
    } else {
      // marcar que no pasó
      authViewModel.setBiometricAuthenticated(false);

      // navegar al login, redirect decide si mostrar login o splash screen
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
