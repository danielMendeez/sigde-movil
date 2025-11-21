import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigde/viewmodels/auth/auth_viewmodel.dart';

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
    await Future.delayed(const Duration(milliseconds: 400));

    final auth = context.read<AuthViewModel>();

    while (!auth.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (!mounted) return;

    // Si no está logueado redirigir a login
    if (!auth.isLoggedIn) {
      context.go('/login');
      return;
    }

    // Si está logueado redirigir a dashboard, go_router decidirá si va a dashboard o biometric
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
