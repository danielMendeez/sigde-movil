import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'components/sidebar.dart';
import 'components/home_content.dart';
import 'components/profile_content.dart';
import 'components/settings_content.dart';
import '../../models/user.dart';

class DashboardView extends StatelessWidget {
  final User user; // Recibe el usuario desde el login

  const DashboardView({super.key, required this.user});

  Widget _getContent(int index) {
    switch (index) {
      case 0:
        return HomeContent(user: user);
      case 1:
        return ProfileContent(user: user);
      case 2:
        return SettingsContent(user: user);
      default:
        return HomeContent(user: user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context);
    final currentIndex = viewModel.selectedIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${user.nombre}!'),
        centerTitle: true,
      ),
      drawer: Sidebar(user: user),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getContent(currentIndex),
      ),
    );
  }
}
