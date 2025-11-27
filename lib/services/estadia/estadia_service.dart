import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/models/estadia/ver_estadia_request.dart';
import 'package:sigde/models/estadia/actualizar_estadia_request.dart';
import 'package:sigde/models/estadia/eliminar_estadia_request.dart';

abstract class EstadiaService {
  Future<List<Estadia>> listarEstadias(String token);
  Future<Estadia> registrarEstadia(RegistrarEstadiaRequest request);
  Future<Estadia> verEstadia(VerEstadiaRequest request);
  Future<Estadia> actualizarEstadia(ActualizarEstadiaRequest request);
  Future<void> eliminarEstadia(EliminarEstadiaRequest request);
}
