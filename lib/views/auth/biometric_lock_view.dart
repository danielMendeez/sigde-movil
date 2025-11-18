import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth/biometric_auth_service.dart';

class BiometricLockView extends StatefulWidget {
  const BiometricLockView({super.key});

  @override
  State<BiometricLockView> createState() => _BiometricLockViewState();
}

class _BiometricLockViewState extends State<BiometricLockView> {
  @override
  void initState() {
    super.initState();
    _authFlow();
  }

  Future<void> _authFlow() async {
    final result = await BiometricAuthService.authenticateUser();

    if (!mounted) return;

    if (result) {
      context.go('/dashboard');
    } else {
      // Si falla, lo regresamos al login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
