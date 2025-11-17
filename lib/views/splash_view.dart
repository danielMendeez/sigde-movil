import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth/secure_storage_service.dart';
import '../services/auth/biometric_auth_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final hasToken = await SecureStorageService.hasToken();

    if (!hasToken) {
      if (mounted) context.go('/login');
      return;
    }

    final user = await SecureStorageService.getUser();
    if (user == null) {
      print('⚠️ No se pudo recuperar el usuario, redirigiendo al login...');
      if (mounted) context.go('/login');
      return;
    }

    final isAuthenticated = await BiometricAuthService.authenticateUser();

    if (!mounted) return;

    if (isAuthenticated) {
      context.go('/dashboard', extra: user);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
