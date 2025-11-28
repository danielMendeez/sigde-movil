import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/viewmodels/user/listar_users_viewmodel.dart';
import 'package:sigde/viewmodels/empresa/listar_empresas_viewmodel.dart';
import 'package:sigde/models/empresa/empresa.dart';
import 'package:sigde/viewmodels/carrera/listar_carreras_viewmodel.dart';
import 'package:sigde/models/carrera/carrera.dart';
import 'package:sigde/utils/sanitizer.dart';

class RegistrarEstadiaView extends StatelessWidget {
  final String token;

  const RegistrarEstadiaView({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithRegistrarEstadiaProviders(
      token: token,
      child: const _RegistrarEstadiaViewContent(),
    );
  }
}

class _RegistrarEstadiaViewContent extends StatefulWidget {
  const _RegistrarEstadiaViewContent({Key? key}) : super(key: key);

  @override
  State<_RegistrarEstadiaViewContent> createState() =>
      _RegistrarEstadiaViewContentState();
}

class _RegistrarEstadiaViewContentState
    extends State<_RegistrarEstadiaViewContent> {
  final _formKey = GlobalKey<FormState>();
  String get _token => AppProviders.getToken(context);

  // Controladores para los campos del formulario
  final _alumnoIdController = TextEditingController();
  final _empresaIdController = TextEditingController();
  final _carreraIdController = TextEditingController();
  final _tutorIdController = TextEditingController();
  final _asesorExternoController = TextEditingController();
  final _proyectoNombreController = TextEditingController();
  final _apoyoController = TextEditingController();
  int? _apoyoValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListarUsersViewModel>().cargarUsers();
      context.read<ListarEmpresasViewModel>().cargarEmpresas(_token);
      context.read<ListarCarrerasViewModel>().cargarCarreras(_token);
    });
  }

  @override
  void dispose() {
    // Limpiar controladores
    _alumnoIdController.dispose();
    _empresaIdController.dispose();
    _carreraIdController.dispose();
    _tutorIdController.dispose();
    _asesorExternoController.dispose();
    _proyectoNombreController.dispose();
    _apoyoController.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    _alumnoIdController.clear();
    _empresaIdController.clear();
    _carreraIdController.clear();
    _tutorIdController.clear();
    _asesorExternoController.clear();
    _proyectoNombreController.clear();
    _apoyoController.clear();
    context.read<RegistrarEstadiaViewModel>().resetState();
  }

  void _enviarFormulario() async {
    _alumnoIdController.text = sanitizeNumber(_alumnoIdController.text);
    _empresaIdController.text = sanitizeNumber(_empresaIdController.text);
    _carreraIdController.text = sanitizeNumber(_carreraIdController.text);
    _tutorIdController.text = sanitizeNumber(_tutorIdController.text);
    _asesorExternoController.text = sanitizeName(_asesorExternoController.text);
    _proyectoNombreController.text = sanitizeText(
      _proyectoNombreController.text,
    );
    _apoyoController.text = sanitizeNumber(_apoyoController.text);

    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistrarEstadiaViewModel>();

      // Crear request
      final request = RegistrarEstadiaRequest(
        alumnoId: int.parse(_alumnoIdController.text),
        empresaId: int.parse(_empresaIdController.text),
        carreraId: int.parse(_carreraIdController.text),
        tutorId: int.parse(_tutorIdController.text),
        asesorExterno: sanitizeName(_asesorExternoController.text),
        proyectoNombre: sanitizeText(_proyectoNombreController.text),
        apoyo: int.parse(_apoyoController.text),
      );

      final success = await viewModel.registrarEstadia(request, _token);
      if (success && viewModel.success) {
        // Mostrar mensaje de éxito
        _mostrarDialogoExito(context);
      }
    }
  }

  void _mostrarDialogoExito(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Éxito'),
            ],
          ),
          content: const Text('Estadía registrada correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _limpiarFormulario();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Estadía'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _limpiarFormulario,
            tooltip: 'Limpiar formulario',
          ),
        ],
      ),
      body: Consumer<RegistrarEstadiaViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Mostrar errores
                  if (viewModel.hasError) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => viewModel.limpiarError(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo: Alumno
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
                          labelText: "Alumno",
                          border: OutlineInputBorder(),
                        ),
                        value: vm.alumnoSeleccionado,
                        items: vm.users.map((user) {
                          return DropdownMenuItem(
                            value: user,
                            child: Text("${user.matricula}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          vm.seleccionarAlumno(value);
                          // Guardar el ID en tu controlador actual
                          _alumnoIdController.text = value?.id.toString() ?? "";
                        },
                        validator: (value) {
                          if (value == null) return "Seleccione un alumno";
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Empresa
                  Consumer<ListarEmpresasViewModel>(
                    builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const CircularProgressIndicator();
                      }

                      if (vm.hasError) {
                        return Text("Error: ${vm.errorMessage}");
                      }

                      return DropdownButtonFormField<Empresa>(
                        decoration: const InputDecoration(
                          labelText: "Empresa",
                          border: OutlineInputBorder(),
                        ),
                        value: vm.empresaSeleccionado,
                        items: vm.empresas.map((empresa) {
                          return DropdownMenuItem(
                            value: empresa,
                            child: Text("${empresa.nombre} - ${empresa.rfc}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          vm.seleccionarEmpresa(value);
                          // Guardar el ID en tu controlador actual
                          _empresaIdController.text =
                              value?.id.toString() ?? "";
                        },
                        validator: (value) {
                          if (value == null) return "Seleccione una empresa";
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Carrera
                  Consumer<ListarCarrerasViewModel>(
                    builder: (context, vm, child) {
                      if (vm.isLoading) {
                        return const CircularProgressIndicator();
                      }

                      if (vm.hasError) {
                        return Text("Error: ${vm.errorMessage}");
                      }

                      return DropdownButtonFormField<Carrera>(
                        decoration: const InputDecoration(
                          labelText: "Carrera",
                          border: OutlineInputBorder(),
                        ),
                        value: vm.carreraSeleccionada,
                        items: vm.carreras.map((carrera) {
                          return DropdownMenuItem(
                            value: carrera,
                            child: Text("${carrera.nombre}"),
                          );
                        }).toList(),
                        onChanged: (value) {
                          vm.seleccionarCarrera(value);
                          _carreraIdController.text =
                              value?.id.toString() ?? "";
                        },
                        validator: (value) {
                          if (value == null) return "Seleccione una carrera";
                          return null;
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Campo: Tutor
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
                        value: vm.tutorSeleccionado,
                        items: vm.users.map((user) {
                          return DropdownMenuItem(
                            value: user,
                            child: Text(
                              "${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}",
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          vm.seleccionarTutor(value);
                          // Guardar el ID en tu controlador actual
                          _tutorIdController.text = value?.id.toString() ?? "";
                        },
                        validator: (value) {
                          if (value == null) return "Seleccione un tutor";
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Asesor Externo
                  _buildTextField(
                    controller: _asesorExternoController,
                    label: 'Asesor Externo',
                    hintText: 'Ingrese el nombre del asesor externo',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del asesor externo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Nombre del Proyecto
                  _buildTextField(
                    controller: _proyectoNombreController,
                    label: 'Nombre del Proyecto',
                    hintText: 'Ingrese el nombre del proyecto',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del proyecto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: Apoyo
                  _buildSupportRadio(),
                  const SizedBox(height: 16),

                  // Botón de enviar
                  _buildSubmitButton(viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSupportRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Recibirás algún apoyo?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            // Opción: Sí
            Expanded(
              child: RadioListTile<int>(
                title: Text('Sí'),
                value: 1,
                groupValue: _apoyoValue,
                onChanged: (value) {
                  setState(() {
                    _apoyoValue = value;
                    _apoyoController.text = value.toString();
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            // Opción: No
            Expanded(
              child: RadioListTile<int>(
                title: Text('No'),
                value: 0,
                groupValue: _apoyoValue,
                onChanged: (value) {
                  setState(() {
                    _apoyoValue = value;
                    _apoyoController.text = value.toString();
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
        // // Mostrar campo adicional si selecciona "Sí"
        // if (_apoyoValue == 1) ...[
        //   SizedBox(height: 12),
        //   _buildTextField(
        //     controller:
        //         _tipoApoyoController, // Necesitarás crear este controller
        //     label: 'Tipo de apoyo',
        //     hintText: 'Describa el tipo de apoyo que recibirá',
        //     keyboardType: TextInputType.text,
        //     maxLines: 3,
        //     validator: (value) {
        //       if (_apoyoValue == 1 && (value == null || value.isEmpty)) {
        //         return 'Por favor describa el tipo de apoyo';
        //       }
        //       return null;
        //     },
        //   ),
        // ],
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(RegistrarEstadiaViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: viewModel.isLoading ? null : _enviarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: viewModel.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text('Registrar Estadía', style: TextStyle(fontSize: 16)),
                ],
              ),
      ),
    );
  }
}
