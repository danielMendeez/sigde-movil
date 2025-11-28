import 'package:sigde/models/carrera/carrera.dart';

abstract class CarreraService {
  Future<List<Carrera>> listarCarreras(String token);
}
