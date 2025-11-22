import 'package:get_it/get_it.dart';
import 'package:sigde/services/api_client.dart';
import 'package:sigde/services/estadia/estadia_service.dart';
import 'package:sigde/services/estadia/estadia_service_implementation.dart';
import 'package:sigde/viewmodels/estadia/listar_estadias_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/ver_estadia_viewmodel.dart';
import 'package:sigde/viewmodels/estadia/actualizar_estadia_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Servicios
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<EstadiaService>(
    EstadiaServiceImplementation(getIt<ApiClient>()),
  );

  // ViewModels (Factory para múltiples instancias)
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
}
