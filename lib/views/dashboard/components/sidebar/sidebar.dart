import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigde/viewmodels/dashboard_viewmodel.dart';
import 'package:sigde/models/user.dart';
import 'package:sigde/viewmodels/auth/auth_viewmodel.dart';
import 'admin_sidebar_options.dart';
import 'student_sidebar_options.dart';
import 'teacher_sidebar_options.dart';

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
            accountName: Text('${user.nombre} ${user.apellidoPaterno}'),
            accountEmail: Text('Rol: ${user.tipoUsuario?.toUpperCase()}'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),

          // Opciones específicas por rol
          _buildRoleSpecificOptions(viewModel, selectedIndex, context),

          const Spacer(),
          const Divider(),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificOptions(
    DashboardViewModel viewModel,
    int selectedIndex,
    BuildContext context,
  ) {
    final onMenuTap = () => context.pop(); // Cerrar drawer al seleccionar

    switch (user.tipoUsuario) {
      case 'admin':
        return AdminSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );

      case 'estudiante':
        return StudentSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );

      case 'docente':
        return TeacherSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  ListTile _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
      onTap: () async {
        await _logout(context);
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logout();
    context.go('/login');
  }
}
