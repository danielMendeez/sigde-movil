import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/locator.dart';

// ViewModels auth y dashboard
import 'package:sigde/viewmodels/auth/auth_viewmodel.dart';
import 'package:sigde/viewmodels/dashboard_viewmodel.dart';
import 'package:sigde/viewmodels/auth/login_viewmodel.dart';
import 'package:sigde/viewmodels/auth/register_viewmodel.dart';

// ViewModels de Estadía
import 'package:sigde/viewmodels/estadia/listar_estadias_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/ver_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/actualizar_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/eliminar_estadia_viewmodel.dart';

class AppProviders {
  // Providers globales
  static List<ChangeNotifierProvider<ChangeNotifier>> get globalProviders => [
    ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel()..initialize(),
    ),
    ChangeNotifierProvider<DashboardViewModel>(
      create: (_) => DashboardViewModel(),
    ),
    ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
    ChangeNotifierProvider<RegisterViewModel>(
      create: (_) => RegisterViewModel(),
    ),
  ];

  // Providers de Estadía
  static List<ChangeNotifierProvider<ChangeNotifier>> get estadiaProviders => [
    ChangeNotifierProvider<ListarEstadiasViewModel>(
      create: (_) => getIt<ListarEstadiasViewModel>(),
    ),
    ChangeNotifierProvider<RegistrarEstadiaViewModel>(
      create: (_) => getIt<RegistrarEstadiaViewModel>(),
    ),
    ChangeNotifierProvider<VerEstadiaViewModel>(
      create: (_) => getIt<VerEstadiaViewModel>(),
    ),
    ChangeNotifierProvider<ActualizarEstadiaViewModel>(
      create: (_) => getIt<ActualizarEstadiaViewModel>(),
    ),
    ChangeNotifierProvider<EliminarEstadiaViewModel>(
      create: (_) => getIt<EliminarEstadiaViewModel>(),
    ),
  ];

  // Providers específicos por pantalla
  // Pantalla: Listar Estadías
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get listarEstadiasProviders => [
    ChangeNotifierProvider<ListarEstadiasViewModel>(
      create: (_) => getIt<ListarEstadiasViewModel>(),
    ),
    ChangeNotifierProvider<EliminarEstadiaViewModel>(
      create: (_) => getIt<EliminarEstadiaViewModel>(),
    ),
  ];

  // Pantalla: Registrar Estadía
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get registrarEstadiaProviders => [
    ChangeNotifierProvider<RegistrarEstadiaViewModel>(
      create: (_) => getIt<RegistrarEstadiaViewModel>(),
    ),
  ];

  // Pantalla: Ver/Editar Estadía
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get verEditarEstadiaProviders => [
    ChangeNotifierProvider<VerEstadiaViewModel>(
      create: (_) => getIt<VerEstadiaViewModel>(),
    ),
    ChangeNotifierProvider<ActualizarEstadiaViewModel>(
      create: (_) => getIt<ActualizarEstadiaViewModel>(),
    ),
  ];

  // Wrappers especificos para envolver widgets con providers y token
  static Widget wrapWithListarEstadiasProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: listarEstadiasProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithRegistrarEstadiaProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: registrarEstadiaProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithVerEditarEstadiaProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: verEditarEstadiaProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  // Método helper para obtener el token desde cualquier lugar
  static String getToken(BuildContext context) {
    return InheritedToken.of(context).token;
  }
}

// Wrapper para pasar el token a través del árbol de widgets
class TokenWrapper extends StatelessWidget {
  final String token;
  final Widget child;

  const TokenWrapper({Key? key, required this.token, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedToken(token: token, child: child);
  }
}

// InheritedWidget para compartir el token
class InheritedToken extends InheritedWidget {
  final String token;

  const InheritedToken({Key? key, required this.token, required Widget child})
    : super(key: key, child: child);

  static InheritedToken of(BuildContext context) {
    final InheritedToken? result = context
        .dependOnInheritedWidgetOfExactType<InheritedToken>();
    assert(result != null, 'No InheritedToken found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedToken oldWidget) {
    return token != oldWidget.token;
  }
}
