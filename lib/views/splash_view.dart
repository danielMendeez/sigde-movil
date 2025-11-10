import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth/secure_storage_service.dart';
import '../models/user.dart';
import 'auth/login_view.dart';
import 'dashboard/dashboard_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorageService.getToken();
    final user = await SecureStorageService.getUser();

    if (token != null && token.isNotEmpty && user != null) {
      // Token y usuario encontrados,redirige a dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardView(user: user as User)),
      );
    } else {
      // Si no hay token redirigir a login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
