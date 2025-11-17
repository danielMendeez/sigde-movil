import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'services/auth/secure_storage_service.dart';
import 'views/auth/login_view.dart';
import 'views/auth/register_view.dart';
import 'viewmodels/auth/auth_viewmodel.dart';
import 'views/dashboard/dashboard_view.dart';
import 'views/splash_view.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final authViewModel = context.read<AuthViewModel>();

    if (!authViewModel.isInitialized) {
      return '/splash';
    }

    if (state.matchedLocation == '/splash') {
      return null;
    }

    final isLoggedIn = await SecureStorageService.hasToken();
    final isUserData = await SecureStorageService.hasDataUser();

    final goingToAuth =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !goingToAuth) {
      return '/login';
    }

    if (isLoggedIn && goingToAuth) {
      if (isUserData) {
        return '/dashboard';
      }
    }

    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashView()),
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
