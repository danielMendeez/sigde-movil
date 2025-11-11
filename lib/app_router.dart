import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'services/auth/secure_storage_service.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'views/dashboard/dashboard_view.dart';
import 'models/user.dart';

class AppRouter {
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isLoggedIn = await SecureStorageService.hasToken();
    final goingToAuth =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !goingToAuth) {
      return '/login';
    }

    if (isLoggedIn && goingToAuth) {
      return '/dashboard';
    }

    return null;
  }

  static final GoRouter router = GoRouter(
    routes: [
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
          final user = state.extra as User?;
          return DashboardView(user: user!);
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
