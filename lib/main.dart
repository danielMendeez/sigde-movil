import 'package:flutter/material.dart';
import 'locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';
import 'app_router.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth/login_viewmodel.dart';
import 'viewmodels/auth/register_viewmodel.dart';
import 'viewmodels/auth/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/estadia/listar_estadias_viewmodel.dart';
import 'viewmodels/estadia/ver_estadia_viewmodel.dart';
import 'viewmodels/estadia/actualizar_estadia_viewmodel.dart';
import 'viewmodels/estadia/eliminar_estadia_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  // Inicializar GetIt
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()..initialize()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        // Usar GetIt para proveer los ViewModels de locator
        ChangeNotifierProvider(
          create: (context) => getIt<ListarEstadiasViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<RegistrarEstadiaViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<VerEstadiaViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<ActualizarEstadiaViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<EliminarEstadiaViewModel>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'SIGDE',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
