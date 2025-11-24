import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/listar_cartas_presentacion_request.dart';
import 'package:sigde/models/carta_presentacion/ver_carta_presentacion_request.dart';

abstract class CartaPresentacionService {
  Future<List<CartaPresentacion>> listarCartasPresentacion(
    ListarCartasPresentacionRequest request,
  );
  Future<CartaPresentacion> verCartaPresentacion(
    VerCartaPresentacionRequest request,
  );
}
