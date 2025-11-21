import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/viewmodels/dashboard_viewmodel.dart';
import 'components/sidebar/sidebar.dart';
import 'components/home_content.dart';
import 'components/profile_content.dart';
import 'components/settings_content.dart';
import 'package:sigde/models/user.dart';
import 'package:sigde/views/estadia/listar_estadias_view.dart';

class DashboardView extends StatefulWidget {
  final User user;

  const DashboardView({super.key, required this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Builder(
        builder: (context) {
          return Consumer<DashboardViewModel>(
            builder: (context, viewModel, child) {
              return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text('Bienvenido, ${widget.user.nombre}!'),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                drawer: Sidebar(user: widget.user),
                body: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _getContent(viewModel.selectedIndex),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getContent(int index) {
    switch (index) {
      case 0:
        return HomeContent(key: const ValueKey('home'), user: widget.user);
      case 1:
        return ProfileContent(
          key: const ValueKey('profile'),
          user: widget.user,
        );
      case 2:
        return SettingsContent(
          key: const ValueKey('settings'),
          user: widget.user,
        );
      case 3:
        return ListarEstadiasView(
          key: const ValueKey('estadias'),
          token: widget.user.token,
        );
      default:
        return HomeContent(
          key: const ValueKey('home-default'),
          user: widget.user,
        );
    }
  }
}
