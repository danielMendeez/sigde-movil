import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/viewmodels/auth/register_viewmodel.dart';
import 'custom_text_field.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController apellidoPaternoController;
  final TextEditingController apellidoMaternoController;
  final TextEditingController curpController;
  final TextEditingController numSeguridadSocialController;
  final TextEditingController matriculaController;
  final TextEditingController correoController;
  final TextEditingController telefonoController;
  final TextEditingController passwordController;
  final String? selectedTipoUsuario;
  final Function(String?) onTipoUsuarioChanged;

  const RegisterForm({
    super.key,
    required this.nombreController,
    required this.apellidoPaternoController,
    required this.apellidoMaternoController,
    required this.curpController,
    required this.numSeguridadSocialController,
    required this.matriculaController,
    required this.correoController,
    required this.telefonoController,
    required this.passwordController,
    required this.selectedTipoUsuario,
    required this.onTipoUsuarioChanged,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Column(
      children: [
        // Nombre
        CustomTextField(
          controller: nombreController,
          labelText: 'Nombre',
          prefixIcon: Icons.person_outline,
          errorText: viewModel.nombreError,
          onChanged: (value) => viewModel.clearNombreError(),
        ),
        const SizedBox(height: 16),

        // Apellido Paterno
        CustomTextField(
          controller: apellidoPaternoController,
          labelText: 'Apellido Paterno',
          prefixIcon: Icons.person_outline,
          errorText: viewModel.apellidoPaternoError,
          onChanged: (value) => viewModel.clearApellidoPaternoError(),
        ),
        const SizedBox(height: 16),

        // Apellido Materno
        CustomTextField(
          controller: apellidoMaternoController,
          labelText: 'Apellido Materno',
          prefixIcon: Icons.person_outline,
          errorText: viewModel.apellidoMaternoError,
          onChanged: (value) => viewModel.clearApellidoMaternoError(),
        ),
        const SizedBox(height: 16),

        // CURP
        CustomTextField(
          controller: curpController,
          labelText: 'CURP',
          prefixIcon: Icons.badge_outlined,
          errorText: viewModel.curpError,
          onChanged: (value) => viewModel.clearCurpError(),
        ),
        const SizedBox(height: 16),

        // Número de Seguridad Social
        CustomTextField(
          controller: numSeguridadSocialController,
          labelText: 'Número de Seguridad Social',
          prefixIcon: Icons.security_outlined,
          errorText: viewModel.numSeguridadSocialError,
          onChanged: (value) => viewModel.clearNumSeguridadSocialError(),
        ),
        const SizedBox(height: 16),

        // Matrícula
        CustomTextField(
          controller: matriculaController,
          labelText: 'Matrícula',
          prefixIcon: Icons.school_outlined,
          errorText: viewModel.matriculaError,
          onChanged: (value) => viewModel.clearMatriculaError(),
        ),
        const SizedBox(height: 16),

        // Correo
        CustomTextField(
          controller: correoController,
          labelText: 'Correo electrónico',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.correoError,
          onChanged: (value) => viewModel.clearCorreoError(),
        ),
        const SizedBox(height: 16),

        // Teléfono
        CustomTextField(
          controller: telefonoController,
          labelText: 'Teléfono',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          errorText: viewModel.telefonoError,
          onChanged: (value) => viewModel.clearTelefonoError(),
        ),
        const SizedBox(height: 16),

        // Tipo de Usuario
        _buildTipoUsuarioDropdown(viewModel),
        if (viewModel.tipoUsuarioError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              viewModel.tipoUsuarioError!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Contraseña
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

  Widget _buildTipoUsuarioDropdown(RegisterViewModel viewModel) {
    final hasError = viewModel.tipoUsuarioError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: hasError
                ? Border.all(color: Colors.red[300]!, width: 1)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedTipoUsuario,
              onChanged: onTipoUsuarioChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Tipo de Usuario',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'estudiante',
                  child: Text('Estudiante'),
                ),
                DropdownMenuItem(value: 'docente', child: Text('Docente')),
                DropdownMenuItem(value: 'admin', child: Text('Administrador')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
