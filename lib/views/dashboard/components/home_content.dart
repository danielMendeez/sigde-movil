import 'package:flutter/material.dart';
import 'package:sigde/models/user.dart';

class HomeContent extends StatelessWidget {
  final User user;

  const HomeContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bienvenido al panel principal, ${user.nombre} 👋\nRol: ${user.tipoUsuario}',
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }
}
