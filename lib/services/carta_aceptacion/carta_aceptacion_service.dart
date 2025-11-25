import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';

abstract class CartaAceptacionService {
  Future<List<CartaAceptacion>> listarCartasAceptacion(String token);
}
