import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/estadia/registrar_estadia_request.dart';
import 'package:sigde/viewmodels/estadia/registrar_estadia_viewmodel.dart';

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
  final _idDocenteController = TextEditingController();
  final _empresaIdController = TextEditingController();
  final _asesorExternoController = TextEditingController();
  final _proyectoNombreController = TextEditingController();
  final _duracionSemanasController = TextEditingController();
  final _apoyoController = TextEditingController();

  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    // Inicializar fechas por defecto
    _fechaInicio = DateTime.now();
    _fechaFin = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    // Limpiar controladores
    _alumnoIdController.dispose();
    _idDocenteController.dispose();
    _empresaIdController.dispose();
    _asesorExternoController.dispose();
    _proyectoNombreController.dispose();
    _duracionSemanasController.dispose();
    _apoyoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFechaInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
        // Ajustar fecha fin si es anterior a fecha inicio
        if (_fechaFin.isBefore(picked)) {
          _fechaFin = picked.add(const Duration(days: 30));
        }
      });
    }
  }

  Future<void> _seleccionarFechaFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin,
      firstDate: _fechaInicio,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fechaFin) {
      setState(() {
        _fechaFin = picked;
      });
    }
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    _alumnoIdController.clear();
    _idDocenteController.clear();
    _empresaIdController.clear();
    _asesorExternoController.clear();
    _proyectoNombreController.clear();
    _duracionSemanasController.clear();
    _apoyoController.clear();
    setState(() {
      _fechaInicio = DateTime.now();
      _fechaFin = DateTime.now().add(const Duration(days: 30));
    });
    context.read<RegistrarEstadiaViewModel>().resetState();
  }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistrarEstadiaViewModel>();

      // Crear request
      final request = RegistrarEstadiaRequest(
        token: _token,
        alumnoId: int.parse(_alumnoIdController.text),
        idDocente: int.parse(_idDocenteController.text),
        empresaId: int.parse(_empresaIdController.text),
        asesorExterno: _asesorExternoController.text,
        proyectoNombre: _proyectoNombreController.text,
        duracionSemanas: int.parse(_duracionSemanasController.text),
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        apoyo: _apoyoController.text,
      );

      final success = await viewModel.registrarEstadia(request);

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

                  // Campo: ID Alumno
                  _buildTextField(
                    controller: _alumnoIdController,
                    label: 'ID Alumno',
                    hintText: 'Ingrese el ID del alumno',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID del alumno';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: ID Docente
                  _buildTextField(
                    controller: _idDocenteController,
                    label: 'ID Docente',
                    hintText: 'Ingrese el ID del docente',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID del docente';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo: ID Empresa
                  _buildTextField(
                    controller: _empresaIdController,
                    label: 'ID Empresa',
                    hintText: 'Ingrese el ID de la empresa',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el ID de la empresa';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      return null;
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
                        return 'Por favor ingrese el nombre del asesor';
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

                  // Campo: Duración en Semanas
                  _buildTextField(
                    controller: _duracionSemanasController,
                    label: 'Duración (semanas)',
                    hintText: 'Ingrese la duración en semanas',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la duración';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Ingrese un número válido';
                      }
                      if (int.parse(value) <= 0) {
                        return 'La duración debe ser mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Fecha Inicio
                  _buildDateField(
                    context: context,
                    label: 'Fecha Inicio',
                    selectedDate: _fechaInicio,
                    onTap: () => _seleccionarFechaInicio(context),
                  ),
                  const SizedBox(height: 16),

                  // Fecha Fin
                  _buildDateField(
                    context: context,
                    label: 'Fecha Fin',
                    selectedDate: _fechaFin,
                    onTap: () => _seleccionarFechaFin(context),
                  ),
                  const SizedBox(height: 16),

                  // Campo: Apoyo
                  _buildTextField(
                    controller: _apoyoController,
                    label: 'Tipo de Apoyo',
                    hintText: 'Describa el tipo de apoyo',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el tipo de apoyo';
                      }
                      return null;
                    },
                  ),
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

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required DateTime selectedDate,
    required VoidCallback onTap,
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
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 12),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
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
