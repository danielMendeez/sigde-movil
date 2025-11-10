import 'package:flutter/material.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Configuraciones de la aplicación ⚙️',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
