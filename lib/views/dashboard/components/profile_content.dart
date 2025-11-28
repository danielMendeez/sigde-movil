import 'package:flutter/material.dart';
import 'package:sigde/models/user/user.dart';

class ProfileContent extends StatelessWidget {
  final User user;

  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Encabezado con degradado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Avatar con inicial
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Text(
                    (user.nombre ?? '').isNotEmpty
                        ? (user.nombre ?? '').substring(0, 1).toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Nombre
                Text(
                  user.nombre ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                // Correo
                if (user.correo != null && user.correo!.isNotEmpty)
                  Text(
                    user.correo!,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Contenido tipo lista
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text(
                  "Información del usuario",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),

                // TARJETA - Rol
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.work_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: const Text(
                      "Tipo de usuario",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(user.tipoUsuario ?? ''),
                  ),
                ),

                const SizedBox(height: 15),

                // TARJETA - Nombre
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: const Text(
                      "Nombre",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(user.nombre ?? ''),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
