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
import 'package:sigde/views/legal/privacy_policy_modal.dart';
import 'package:sigde/views/legal/terms_of_service_modal.dart';
import 'package:flutter/cupertino.dart';

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
    context.go('/register');
  }

  void _onPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PrivacyPolicyModal(),
    );
  }

  void _onTermsOfService() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TermsOfServiceModal(),
    );
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
                const SizedBox(height: 5),
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
      imagePath: 'assets/images/uth.png',
      imageSize: 300,
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

          final wantsBiometric = await _showAlertDialogMaterial(context);

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
      copyrightText: '© 2025 CreaCode. Todos los derechos reservados.',
      versionText: 'v1.0.0',
      links: [
        FooterLink(text: 'Política de privacidad', onTap: _onPrivacyPolicy),
        FooterLink(text: 'Términos de servicio', onTap: _onTermsOfService),
      ],
      showDivider: true,
    );
  }

  Future<bool?> _showAlertDialogMaterial(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Alert',
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, _, _) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (ctx, anim, _, _) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(
            opacity: anim.value,
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _DialogContent(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(18),
          child: Icon(Icons.fingerprint, size: 48, color: Colors.green[700]),
        ),
        const SizedBox(height: 20),
        Text(
          "¿Habilitar biométricos?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          "¿Deseas activar el inicio de sesión con huella o reconocimiento facial para futuros accesos?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.4),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green[700],
                  side: BorderSide(color: Colors.green[400]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No, gracias"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Sí, habilitar"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
