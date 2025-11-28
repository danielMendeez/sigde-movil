import 'package:sigde/models/user/user.dart';

abstract class UserService {
  Future<List<User>> listarUsuarios();
}
