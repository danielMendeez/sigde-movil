import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/login_viewmodel.dart';
import '../../models/user.dart';
import '../../views/dashboard/dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

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
                _buildHeaderSection(),
                const SizedBox(height: 40),
                _buildEmailField(viewModel),
                _buildEmailError(viewModel),
                const SizedBox(height: 16),
                _buildPasswordField(viewModel),
                _buildPasswordError(viewModel),
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

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.green[300]!, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.green[100]!,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRect(
              child: Image.asset(
                'assets/images/icon_256.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia sesión en tu cuenta',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(LoginViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: viewModel.correoError != null
            ? Border.all(color: Colors.red[300]!, width: 1)
            : null,
      ),
      child: TextField(
        controller: _correoController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          labelStyle: TextStyle(
            color: viewModel.correoError != null
                ? Colors.red[700]
                : Colors.green[700],
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: viewModel.correoError != null
                ? Colors.red[600]
                : Colors.green[600],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: viewModel.correoError != null
              ? Colors.red[800]
              : Colors.green[800],
        ),
        onChanged: (value) => viewModel.clearCorreoError(),
      ),
    );
  }

  Widget _buildEmailError(LoginViewModel viewModel) {
    return viewModel.correoError != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              viewModel.correoError!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildPasswordField(LoginViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: viewModel.passwordError != null
            ? Border.all(color: Colors.red[300]!, width: 1)
            : null,
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: TextStyle(
            color: viewModel.passwordError != null
                ? Colors.red[700]
                : Colors.green[700],
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: viewModel.passwordError != null
                ? Colors.red[600]
                : Colors.green[600],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: viewModel.passwordError != null
              ? Colors.red[800]
              : Colors.green[800],
        ),
        onChanged: (value) => viewModel.clearPasswordError(),
      ),
    );
  }

  Widget _buildPasswordError(LoginViewModel viewModel) {
    return viewModel.passwordError != null
        ? Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              viewModel.passwordError!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    if (viewModel.isLoading) {
      return Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.green[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () async {
        final user = await viewModel.login(
          _correoController.text,
          _passwordController.text,
        );

        if (user != null && context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardView(user: user)),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildViewModelError(LoginViewModel viewModel) {
    return viewModel.errorMessage != null
        ? Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    viewModel.errorMessage!,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildFooter() {
    return Text(
      '¿Necesitas ayuda?',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600], fontSize: 14),
    );
  }
}
