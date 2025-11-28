import 'package:get_it/get_it.dart';
import 'package:sigde/services/api_client.dart';

// Servicios - Estadía
import 'package:sigde/services/estadia/estadia_service.dart';
import 'package:sigde/services/estadia/estadia_service_implementation.dart';

// ViewModels - Estadía
import 'package:sigde/viewmodels/estadia/listar_estadias_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/ver_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/actualizar_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/eliminar_estadia_viewmodel.dart';

// Servicios - Carta de Presentación
import 'package:sigde/services/carta_presentacion/carta_presentacion_service.dart';
import 'package:sigde/services/carta_presentacion/carta_presentacion_service_implementation.dart';

// ViewModels - Carta de Presentación
import 'package:sigde/viewmodels/carta_presentacion/listar_cartas_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/ver_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/registrar_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/firmar_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/descargar_carta_presentacion_viewmodel.dart';

// Servicios - Carta de Aceptación
import 'package:sigde/services/carta_aceptacion/carta_aceptacion_service.dart';
import 'package:sigde/services/carta_aceptacion/carta_aceptacion_service_implementation.dart';

// ViewModels - Carta de Aceptación
import 'package:sigde/viewmodels/carta_aceptacion/listar_cartas_aceptacion_viewmodel.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  _setupServices();
  _setupEstadiaViewModels();
  _setupCartaPresentacionViewModels();
  _setupCartasAceptacionViewModels();
}

void _setupServices() {
  getIt.registerSingleton<ApiClient>(ApiClient());

  getIt.registerSingleton<EstadiaService>(
    EstadiaServiceImplementation(getIt<ApiClient>()),
  );

  getIt.registerSingleton<CartaPresentacionService>(
    CartaPresentacionServiceImplementation(getIt<ApiClient>()),
  );

  getIt.registerSingleton<CartaAceptacionService>(
    CartaAceptacionServiceImplementation(getIt<ApiClient>()),
  );
}

void _setupEstadiaViewModels() {
  getIt.registerFactory<ListarEstadiasViewModel>(
    () => ListarEstadiasViewModel(getIt<EstadiaService>()),
  );
  getIt.registerFactory<RegistrarEstadiaViewModel>(
    () => RegistrarEstadiaViewModel(getIt<EstadiaService>()),
  );
  getIt.registerFactory<VerEstadiaViewModel>(
    () => VerEstadiaViewModel(getIt<EstadiaService>()),
  );
  getIt.registerFactory<ActualizarEstadiaViewModel>(
    () => ActualizarEstadiaViewModel(getIt<EstadiaService>()),
  );
  getIt.registerFactory<EliminarEstadiaViewModel>(
    () => EliminarEstadiaViewModel(getIt<EstadiaService>()),
  );
}

void _setupCartaPresentacionViewModels() {
  getIt.registerFactory<ListarCartasPresentacionViewModel>(
    () => ListarCartasPresentacionViewModel(getIt<CartaPresentacionService>()),
  );
  getIt.registerFactory<VerCartaPresentacionViewModel>(
    () => VerCartaPresentacionViewModel(getIt<CartaPresentacionService>()),
  );
  getIt.registerFactory<RegistrarCartaPresentacionViewModel>(
    () =>
        RegistrarCartaPresentacionViewModel(getIt<CartaPresentacionService>()),
  );
  getIt.registerFactory<FirmarCartaPresentacionViewModel>(
    () => FirmarCartaPresentacionViewModel(getIt<CartaPresentacionService>()),
  );
  getIt.registerFactory<DescargarCartaPresentacionViewModel>(
    () =>
        DescargarCartaPresentacionViewModel(getIt<CartaPresentacionService>()),
  );
}

void _setupCartasAceptacionViewModels() {
  getIt.registerFactory<ListarCartasAceptacionViewModel>(
    () => ListarCartasAceptacionViewModel(getIt<CartaAceptacionService>()),
  );
}
