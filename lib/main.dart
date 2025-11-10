import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/views/splash_view.dart';
import 'viewmodels/auth/login_viewmodel.dart';
import 'views/auth/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginViewModel())],
      child: MaterialApp(
        title: 'Sistema Estudiantil',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashView(),
      ),
    );
  }
}
