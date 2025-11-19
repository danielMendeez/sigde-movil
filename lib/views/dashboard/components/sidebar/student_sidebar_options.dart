import 'package:flutter/material.dart';
import 'package:sigde/viewmodels/dashboard_viewmodel.dart';

class StudentSidebarOptions extends StatelessWidget {
  final DashboardViewModel viewModel;
  final int selectedIndex;
  final VoidCallback onMenuTap;

  const StudentSidebarOptions({
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
          icon: Icons.school,
          title: 'Mi Perfil',
        ),
        // Más opciones estudiantiles...
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
