import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/carta_presentacion/registrar_carta_presentacion_request.dart';
import 'package:sigde/viewmodels/carta_presentacion/registrar_carta_presentacion_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/viewmodels/user/listar_users_viewmodel.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/viewmodels/estadia/listar_estadias_viewmodel.dart';

class RegistrarCartaPresentacionView extends StatelessWidget {
  final String token;

  const RegistrarCartaPresentacionView({Key? key, required this.token})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithRegistrarCartaPresentacionProviders(
      token: token,
      child: const _RegistrarCartaPresentacionViewContent(),
    );
  }
}

class _RegistrarCartaPresentacionViewContent extends StatefulWidget {
  const _RegistrarCartaPresentacionViewContent({Key? key}) : super(key: key);

  @override
  State<_RegistrarCartaPresentacionViewContent> createState() =>
      _RegistrarCartaPresentacionViewContentState();
}

class _RegistrarCartaPresentacionViewContentState
    extends State<_RegistrarCartaPresentacionViewContent> {
  String get _token => AppProviders.getToken(context);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _estadiaIdController = TextEditingController();
  final TextEditingController _directorIdController = TextEditingController();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListarUsersViewModel>().cargarUsers();
      context.read<ListarEstadiasViewModel>().cargarEstadias(_token);
    });
  }

  @override
  void dispose() {
    _estadiaIdController.dispose();
    _directorIdController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _estadiaIdController.clear();
    _directorIdController.clear();
  }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistrarCartaPresentacionViewModel>();

      final request = RegistrarCartaPresentacionRequest(
        estadiaId: int.parse(_estadiaIdController.text),
        directorId: int.parse(_directorIdController.text),
      );

      final success = await viewModel.registrarCartaPresentacion(
        request,
        _token,
      );

      if (success && viewModel.success) {
        // Mostrar mensaje de éxito
        _mostrarDialogoExito(context);
      }
    }
  }

  void _mostrarDialogoExito(BuildContext context) {
    Fluttertoast.showToast(
      msg: "Carta de presentación registrada exitosamente",
      toastLength: Toast.LENGTH_LONG,
    );
    Navigator.of(context).pop();
    _clearForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Carta de Presentación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Estadía
              Consumer<ListarEstadiasViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (vm.hasError) {
                    return Text("Error: ${vm.errorMessage}");
                  }

                  return DropdownButtonFormField<Estadia>(
                    decoration: const InputDecoration(
                      labelText: "Estadia",
                      border: OutlineInputBorder(),
                    ),
                    value: vm.estadiaSeleccionada,
                    items: vm.estadias.map((estadia) {
                      return DropdownMenuItem(
                        value: estadia,
                        child: Text(
                          "${estadia.proyectoNombre}", // ajusta campo si tu modelo usa otros nombres
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      vm.seleccionarEstadia(value);
                      _estadiaIdController.text = value?.id.toString() ?? "";
                    },
                    validator: (value) {
                      if (value == null) return "Seleccione una estadía";
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Selector de Tutor
              Consumer<ListarUsersViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const CircularProgressIndicator();
                  }

                  if (vm.hasError) {
                    return Text("Error: ${vm.errorMessage}");
                  }

                  return DropdownButtonFormField<User>(
                    decoration: const InputDecoration(
                      labelText: "Tutor",
                      border: OutlineInputBorder(),
                    ),
                    value: vm.alumnoSeleccionado,
                    items: vm.users.map((user) {
                      return DropdownMenuItem(
                        value: user,
                        child: Text(
                          "${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}",
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      vm.seleccionarAlumno(value);
                      // Guardar el ID en tu controlador actual
                      _directorIdController.text = value?.id.toString() ?? "";
                    },
                    validator: (value) {
                      if (value == null) return "Seleccione un alumno";
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              // Botón de enviar
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required String label,
    required TextEditingController controller,
    required List<Map<String, dynamic>> items,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hint,
          ),
          value: controller.text.isEmpty ? null : int.parse(controller.text),
          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: item['id'],
              child: Text(item['nombre']),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value.toString();
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona una $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _enviarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Registrar Carta de Presentación',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
