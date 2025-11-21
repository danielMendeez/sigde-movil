import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/models/estadia/listar_estadias_request.dart';

abstract class EstadiaService {
  Future<List<Estadia>> listarEstadias(ListarEstadiasRequest request);
}
