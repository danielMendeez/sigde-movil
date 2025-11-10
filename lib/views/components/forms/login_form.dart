import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth/login_viewmodel.dart';
import 'custom_text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController correoController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.correoController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Column(
      children: [
        CustomTextField(
          controller: correoController,
          labelText: 'Correo electrónico',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.correoError,
          onChanged: (value) => viewModel.clearCorreoError(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          labelText: 'Contraseña',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          errorText: viewModel.passwordError,
          onChanged: (value) => viewModel.clearPasswordError(),
        ),
      ],
    );
  }
}
