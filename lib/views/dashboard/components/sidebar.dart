import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../../models/user.dart';
import '../../../services/auth/secure_storage_service.dart';

class Sidebar extends StatelessWidget {
  final User user;
  const Sidebar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final selectedIndex = viewModel.selectedIndex;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Nombre: ${user.nombre}'),
            accountEmail: Text('Rol: ${user.tipoUsuario}'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            selected: selectedIndex == 0,
            onTap: () {
              viewModel.changeTab(0);
              // Usar go_router para cerrar el drawer
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            selected: selectedIndex == 1,
            onTap: () {
              viewModel.changeTab(1);
              context.pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuraciones'),
            selected: selectedIndex == 2,
            onTap: () {
              viewModel.changeTab(2);
              context.pop();
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              await _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SecureStorageService.deleteAll();

    // Usar go_router para redireccionar al login
    context.go('/login');
  }
}
