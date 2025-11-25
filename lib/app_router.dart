import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/auth/biometric_lock_view.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/splash_view.dart';
import 'viewmodels/auth/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final auth = context.read<AuthViewModel>();

    // Esperar inicialización antes de redirigir
    if (!auth.isInitialized) return '/splash';

    final loggedIn = auth.isLoggedIn;
    final biometricEnabled = auth.biometricEnabled;
    final biometricPassed = auth.biometricAuthenticated;

    final goingToAuth =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    // Si no está logueado ir a login
    if (!loggedIn) {
      if (!goingToAuth) return '/login';
      return null;
    }

    // Si está logueado pero biometría no está activa permitir dashboard
    if (!biometricEnabled) return null;

    // Si está logueado y biometría activada pero ya pasó la biometría en esta sesión permitir dashboard
    if (biometricPassed) return null;

    // Si está logueado y biometría activada y no ha pasado en esta sesión:
    // permitir que el usuario vaya a la pantalla de login/register (fallback),
    // pero para cualquier otra ruta forzamos /biometric.
    if (goingToAuth) return null;

    if (state.matchedLocation != '/biometric') {
      return '/biometric';
    }

    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
      GoRoute(
        path: '/biometric',
        name: 'biometric',
        builder: (context, state) => const BiometricLockView(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => LoginView(
          successMessage: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginView(
          successMessage: state.extra is String ? state.extra as String : null,
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) {
          final authViewModel = context.read<AuthViewModel>();
          final user = authViewModel.currentUser;

          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/login');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return DashboardView(user: user);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
    redirect: _redirect,
  );
}
