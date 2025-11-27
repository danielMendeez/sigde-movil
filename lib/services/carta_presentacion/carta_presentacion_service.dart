import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/models/carta_presentacion/ver_carta_presentacion_request.dart';

abstract class CartaPresentacionService {
  Future<List<CartaPresentacion>> listarCartasPresentacion(String token);
  Future<CartaPresentacion> verCartaPresentacion(
    VerCartaPresentacionRequest request,
    String token,
  );
}
