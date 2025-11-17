import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth/auth_viewmodel.dart';
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

    final authViewModel = context.read<AuthViewModel>();

    // Esperar a que el AuthViewModel se inicialice
    while (!authViewModel.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final isAuthenticated = await BiometricAuthService.authenticateUser();
    if (!mounted) return;

    if (authViewModel.isLoggedIn && isAuthenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
