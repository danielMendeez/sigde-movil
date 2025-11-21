import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sigde/viewmodels/auth/login_viewmodel.dart';
import 'package:sigde/viewmodels/auth/auth_viewmodel.dart';
import 'package:sigde/services/auth/secure_storage_service.dart';
import 'package:sigde/views/components/layout/form_header.dart';
import 'package:sigde/views/components/layout/form_footer.dart';
import 'package:sigde/views/components/forms/login_form.dart';
import 'package:sigde/views/components/buttons/primary_button.dart';
import 'package:sigde/views/components/feedback/error_message.dart';

class LoginView extends StatefulWidget {
  final String? successMessage;

  const LoginView({Key? key, this.successMessage}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.successMessage != null && widget.successMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.successMessage!),
              backgroundColor: Colors.green[600],
            ),
          );
        }
      });
    }
  }

  void _onRegister() {
    // Navegar a la vista de registro
    // print('Navegar a registro');
    context.go('/register');
  }

  void _onForgotPassword() {
    // Navegar a la vista de recuperación de contraseña
    print('Navegar a recuperación de contraseña');
  }

  void _onContactSupport() {
    // Abrir soporte técnico
    print('Abrir soporte técnico');
  }

  void _onPrivacyPolicy() {
    // Abrir política de privacidad
    print('Abrir política de privacidad');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildLoginForm(viewModel),
                const SizedBox(height: 32),
                _buildLoginButton(viewModel),
                _buildViewModelError(viewModel),
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const FormHeader(
      title: 'Bienvenido a SIGDE',
      subtitle: 'Inicia sesión en tu cuenta',
      imagePath: 'assets/images/icon_256.png',
      imageSize: 80,
    );
  }

  Widget _buildLoginForm(LoginViewModel viewModel) {
    return LoginForm(
      correoController: _correoController,
      passwordController: _passwordController,
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return PrimaryButton(
      text: 'Iniciar Sesión',
      onPressed: () async {
        final authViewModel = context.read<AuthViewModel>();
        final user = await viewModel.login(
          _correoController.text,
          _passwordController.text,
        );

        if (user != null && context.mounted) {
          await authViewModel.setUser(user);

          // Después de login exitoso, preguntar si desea activar biometría
          final wantsBiometric = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Activar inicio con huella/rostro"),
              content: const Text(
                "¿Deseas habilitar el inicio de sesión biométrico "
                "para futuras veces?",
              ),
              actions: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Sí"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          );

          // Si presiona "Sí", guardamos la preferencia
          if (wantsBiometric == true) {
            await SecureStorageService.setBiometricEnabled(true);
          }

          context.go('/dashboard', extra: user);
        }
      },
      isLoading: viewModel.isLoading,
      backgroundColor: Colors.green[600],
    );
  }

  Widget _buildViewModelError(LoginViewModel viewModel) {
    return viewModel.errorMessage != null
        ? ErrorMessage(message: viewModel.errorMessage!)
        : const SizedBox.shrink();
  }

  Widget _buildFooter() {
    return FormFooter(
      helpText: '¿No tienes una cuenta?',
      primaryLink: FooterLink(text: 'Regístrate aquí', onTap: _onRegister),
      copyrightText: '© 2024 Mi Empresa. Todos los derechos reservados.',
      versionText: 'v1.0.0',
      links: [
        // FooterLink(text: '¿Olvidaste tu contraseña?', onTap: _onForgotPassword),
        FooterLink(text: '¿Olvidaste tu contraseña?', onTap: _onForgotPassword),
        FooterLink(text: 'Contactar soporte', onTap: _onContactSupport),
        FooterLink(text: 'Política de privacidad', onTap: _onPrivacyPolicy),
      ],
      showDivider: true,
    );
  }
}
