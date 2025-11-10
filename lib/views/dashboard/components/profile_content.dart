import 'package:flutter/material.dart';
import '../../../models/user.dart';

class ProfileContent extends StatelessWidget {
  final User user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Perfil del usuario:\n\nNombre: ${user.nombre}\nTipo: ${user.tipoUsuario}',
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
