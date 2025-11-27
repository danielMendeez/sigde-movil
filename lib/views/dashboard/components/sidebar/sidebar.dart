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
      width: 270,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Header mejorado
          _buildUserHeader(context),

          // Opciones específicas por rol
          Expanded(
            child: _buildRoleSpecificOptions(viewModel, selectedIndex, context),
          ),

          // Footer con configuración y logout
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15)),
      ),
      child: Row(
        children: [
          // Avatar compacto
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                radius: 18,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.nombre} ${user.apellidoPaterno}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.tipoUsuario?.toUpperCase() ?? 'USUARIO',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpecificOptions(
    DashboardViewModel viewModel,
    int selectedIndex,
    BuildContext context,
  ) {
    final onMenuTap = () => context.pop();

    Widget optionsWidget;

    switch (user.tipoUsuario) {
      case 'admin':
        optionsWidget = AdminSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );
        break;
      case 'estudiante':
        optionsWidget = StudentSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );
        break;
      case 'docente':
        optionsWidget = TeacherSidebarOptions(
          viewModel: viewModel,
          selectedIndex: selectedIndex,
          onMenuTap: onMenuTap,
        );
        break;
      default:
        optionsWidget = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: optionsWidget,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildSettingsTile(context),
          const SizedBox(height: 8),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.logout_rounded,
            size: 20,
            color: Colors.red.shade600,
          ),
        ),
        title: Text(
          'Cerrar sesión',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.red.shade600.withOpacity(0.6),
        ),
        onTap: () => _logout(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.settings_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'Configuración',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        onTap: () {
          context.pop();
          final viewModel = Provider.of<DashboardViewModel>(
            context,
            listen: false,
          );
          viewModel.changeTab(2);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.logout();
    context.go('/login');
  }
}
