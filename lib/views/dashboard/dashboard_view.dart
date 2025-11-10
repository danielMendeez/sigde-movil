import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/home_content.dart';
import 'components/settings_content.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  Widget _getContent(int index) {
    switch (index) {
      case 0:
        return const HomeContent();
      case 1:
        return const SettingsContent();
      default:
        return const HomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Control'), centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                (context as Element).markNeedsBuild();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuraciones'),
              onTap: () {
                Navigator.pop(context);
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        ),
      ),
    );
  }
}
