import 'package:sigde/models/empresa/empresa.dart';

abstract class EmpresaService {
  Future<List<Empresa>> listarEmpresas(String token);
}
