import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/models/carta_aceptacion/ver_carta_aceptacion_request.dart';

abstract class CartaAceptacionService {
  Future<List<CartaAceptacion>> listarCartasAceptacion(String token);
  Future<CartaAceptacion> verCartaAceptacion(
    VerCartaAceptacionRequest request,
    String token,
  );
}
