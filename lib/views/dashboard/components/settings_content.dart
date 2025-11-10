import 'package:flutter/material.dart';
import '../../../models/user.dart';

class SettingsContent extends StatelessWidget {
  final User user;

  const SettingsContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Configuraciones del usuario: ${user.nombre}',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
