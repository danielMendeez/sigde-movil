import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/register_viewmodel.dart';
import '../components/layout/form_header.dart';
import '../components/layout/form_footer.dart';
import '../components/forms/register_form.dart';
import '../components/buttons/primary_button.dart';
import '../components/feedback/error_message.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nombreController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _curpController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedTipoUsuario;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _curpController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // Navegar a la vista de login
    context.go('/login');
  }

  void _onPrivacyPolicy() {
    // Abrir política de privacidad
    print('Abrir política de privacidad');
  }

  void _onTermsOfService() {
    // Abrir términos de servicio
    print('Abrir términos de servicio');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

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
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildRegisterForm(viewModel),
                const SizedBox(height: 24),
                _buildRegisterButton(viewModel),
                _buildViewModelError(viewModel),
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
      title: 'Crear Cuenta',
      subtitle: 'Regístrate para comenzar',
      imagePath: 'assets/images/icon_256.png',
      imageSize: 70,
    );
  }

  Widget _buildRegisterForm(RegisterViewModel viewModel) {
    return RegisterForm(
      nombreController: _nombreController,
      apellidoPaternoController: _apellidoPaternoController,
      apellidoMaternoController: _apellidoMaternoController,
      curpController: _curpController,
      correoController: _correoController,
      telefonoController: _telefonoController,
      passwordController: _passwordController,
      selectedTipoUsuario: _selectedTipoUsuario,
      onTipoUsuarioChanged: (value) {
        setState(() {
          _selectedTipoUsuario = value;
        });
        viewModel.clearTipoUsuarioError();
      },
    );
  }

  Widget _buildRegisterButton(RegisterViewModel viewModel) {
    return PrimaryButton(
      text: 'Registrarse',
      onPressed: () async {
        final user = await viewModel.register(
          nombre: _nombreController.text,
          apellidoPaterno: _apellidoPaternoController.text,
          apellidoMaterno: _apellidoMaternoController.text,
          curp: _curpController.text,
          correo: _correoController.text,
          telefono: _telefonoController.text,
          tipoUsuario: _selectedTipoUsuario ?? '',
          password: _passwordController.text,
        );

        if (user != null && context.mounted) {
          // Redirigir al login pasando un mensaje de éxito
          context.go(
            '/login',
            extra: 'Tu cuenta se creó correctamente. Por favor inicia sesión.',
          );
        }
      },
      isLoading: viewModel.isLoading,
      backgroundColor: Colors.green[600],
    );
  }

  Widget _buildViewModelError(RegisterViewModel viewModel) {
    return viewModel.errorMessage != null
        ? ErrorMessage(message: viewModel.errorMessage!)
        : const SizedBox.shrink();
  }

  Widget _buildFooter() {
    return FormFooter(
      helpText: '¿Ya tienes una cuenta?',
      primaryLink: FooterLink(text: 'Inicia sesión aquí', onTap: _onLogin),
      copyrightText: '© 2024 Mi Empresa. Todos los derechos reservados.',
      versionText: 'v1.0.0',
      links: [
        FooterLink(text: 'Política de privacidad', onTap: _onPrivacyPolicy),
        FooterLink(text: 'Términos de servicio', onTap: _onTermsOfService),
      ],
      showDivider: true,
    );
  }
}
