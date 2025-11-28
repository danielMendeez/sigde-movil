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

// ViewModels de Carta de Presentación
import 'package:sigde/viewmodels/carta_presentacion/listar_cartas_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/ver_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/registrar_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/firmar_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/descargar_carta_presentacion_viewmodel.dart';

// ViewModels de Carta de Aceptación
import 'package:sigde/viewmodels/carta_aceptacion/listar_cartas_aceptacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_aceptacion/ver_carta_aceptacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_aceptacion/registrar_carta_aceptacion_viewmodel.dart';

// ViewModels comunes
import 'package:sigde/viewmodels/user/listar_users_viewmodel.dart';
import 'package:sigde/viewmodels/empresa/listar_empresas_viewmodel.dart';

class AppProviders {
  // PROVIDERS GLOBALES
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

  // PROVIDERS DE ESTADIA
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

  // PROVIDERS DE CARTA DE PRESENTACIÓN
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get cartaPresentacionProviders => [
    ChangeNotifierProvider<ListarCartasPresentacionViewModel>(
      create: (_) => getIt<ListarCartasPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<VerCartaPresentacionViewModel>(
      create: (_) => getIt<VerCartaPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<RegistrarCartaPresentacionViewModel>(
      create: (_) => getIt<RegistrarCartaPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<FirmarCartaPresentacionViewModel>(
      create: (_) => getIt<FirmarCartaPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<DescargarCartaPresentacionViewModel>(
      create: (_) => getIt<DescargarCartaPresentacionViewModel>(),
    ),
  ];

  // PROVIDERS DE CARTA DE ACEPTACIÓN
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get cartaAceptacionProviders => [
    ChangeNotifierProvider<ListarCartasAceptacionViewModel>(
      create: (_) => getIt<ListarCartasAceptacionViewModel>(),
    ),
    ChangeNotifierProvider<VerCartaAceptacionViewModel>(
      create: (_) => getIt<VerCartaAceptacionViewModel>(),
    ),
    ChangeNotifierProvider<RegistrarCartaAceptacionViewModel>(
      create: (_) => getIt<RegistrarCartaAceptacionViewModel>(),
    ),
  ];

  // PROVIDERS COMUNES A VARIAS PANTALLAS
  static List<ChangeNotifierProvider<ChangeNotifier>> get commonProviders => [
    ChangeNotifierProvider<ListarUsersViewModel>(
      create: (_) => getIt<ListarUsersViewModel>(),
    ),
    ChangeNotifierProvider<ListarEmpresasViewModel>(
      create: (_) => getIt<ListarEmpresasViewModel>(),
    ),
  ];

  // PROVIDERS ESPECIFICOS POR PANTALLA
  // ESTADIA
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
    ChangeNotifierProvider<ListarUsersViewModel>(
      create: (_) => getIt<ListarUsersViewModel>(),
    ),
    ChangeNotifierProvider<ListarEmpresasViewModel>(
      create: (_) => getIt<ListarEmpresasViewModel>(),
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

  // CARTA DE PRESENTACIÓN
  // Pantalla: Listar Cartas de Presentación
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get listarCartasPresentacionProviders => [
    ChangeNotifierProvider<ListarCartasPresentacionViewModel>(
      create: (_) => getIt<ListarCartasPresentacionViewModel>(),
    ),
  ];

  // Pantalla: Ver/Editar carta de presentación
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get verFirmarEditarCartaPresentacionProviders => [
    ChangeNotifierProvider<VerCartaPresentacionViewModel>(
      create: (_) => getIt<VerCartaPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<FirmarCartaPresentacionViewModel>(
      create: (_) => getIt<FirmarCartaPresentacionViewModel>(),
    ),
    ChangeNotifierProvider<DescargarCartaPresentacionViewModel>(
      create: (_) => getIt<DescargarCartaPresentacionViewModel>(),
    ),
  ];

  static List<ChangeNotifierProvider<ChangeNotifier>>
  get registrarCartaPresentacionProviders => [
    ChangeNotifierProvider<RegistrarCartaPresentacionViewModel>(
      create: (_) => getIt<RegistrarCartaPresentacionViewModel>(),
    ),
  ];

  // CARTA DE ACEPTACIÓN
  // Pantalla: Listar y ver Cartas de Aceptación
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get listarCartasAceptacionProviders => [
    ChangeNotifierProvider<ListarCartasAceptacionViewModel>(
      create: (_) => getIt<ListarCartasAceptacionViewModel>(),
    ),
  ];

  // Pantalla: Ver Carta de Aceptación
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get verCartaAceptacionProviders => [
    ChangeNotifierProvider<VerCartaAceptacionViewModel>(
      create: (_) => getIt<VerCartaAceptacionViewModel>(),
    ),
  ];

  // Pantalla: Registrar Carta de Aceptación
  static List<ChangeNotifierProvider<ChangeNotifier>>
  get registrarCartaAceptacionProviders => [
    ChangeNotifierProvider<RegistrarCartaAceptacionViewModel>(
      create: (_) => getIt<RegistrarCartaAceptacionViewModel>(),
    ),
  ];

  // WRAPPERS PARA PANTALLAS CON PROVIDERS ESPECIFICOS
  // ESTADIA
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

  // CARTA DE PRESENTACIÓN
  static Widget wrapWithListarCartasPresentacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: listarCartasPresentacionProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithVerFirmarEditarCartaPresentacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: verFirmarEditarCartaPresentacionProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithRegistrarCartaPresentacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: registrarCartaPresentacionProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  // CARTA DE ACEPTACIÓN
  static Widget wrapWithListarCartasAceptacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: listarCartasAceptacionProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithVerCartaAceptacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: verCartaAceptacionProviders,
      child: TokenWrapper(token: token, child: child),
    );
  }

  static Widget wrapWithRegistrarCartaAceptacionProviders({
    required String token,
    required Widget child,
  }) {
    return MultiProvider(
      providers: registrarCartaAceptacionProviders,
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
