import 'package:flutter/material.dart';
import 'package:sigde/viewmodels/dashboard_viewmodel.dart';

class AdminSidebarOptions extends StatelessWidget {
  final DashboardViewModel viewModel;
  final int selectedIndex;
  final VoidCallback onMenuTap;

  const AdminSidebarOptions({
    super.key,
    required this.viewModel,
    required this.selectedIndex,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context: context,
          index: 0,
          icon: Icons.home,
          title: 'Inicio',
        ),
        _buildListTile(
          context: context,
          index: 1,
          icon: Icons.person,
          title: 'Mi Perfil Admin',
        ),
        _buildListTile(
          context: context,
          index: 3,
          icon: Icons.document_scanner,
          title: 'Estadias',
        ),
        // Puedes agregar más opciones específicas de admin
      ],
    );
  }

  ListTile _buildListTile({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedIndex == index,
      onTap: () {
        viewModel.changeTab(index);
        onMenuTap();
      },
    );
  }
}
