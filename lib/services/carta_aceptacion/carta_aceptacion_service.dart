import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/models/carta_aceptacion/ver_carta_aceptacion_request.dart';
import 'package:sigde/models/carta_aceptacion/registrar_carta_aceptacion_request.dart';
import 'dart:io';

abstract class CartaAceptacionService {
  Future<List<CartaAceptacion>> listarCartasAceptacion(String token);
  Future<CartaAceptacion> verCartaAceptacion(
    VerCartaAceptacionRequest request,
    String token,
  );
  Future<CartaAceptacion> registrarCartaAceptacion(
    RegistrarCartaAceptacionRequest request,
    String token,
    File? archivo,
  );
}
