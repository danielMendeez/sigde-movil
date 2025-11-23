import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/estadia/actualizar_estadia_request.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/viewmodels/estadia/actualizar_estadia_viewmodel.dart';
import 'package:sigde/utils/provider_helpers.dart';

class ActualizarEstadiaView extends StatelessWidget {
  final String token;
  final Estadia estadia;

  const ActualizarEstadiaView({
    Key? key,
    required this.token,
    required this.estadia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithVerEditarEstadiaProviders(
      token: token,
      child: _ActualizarEstadiaViewContent(estadia: estadia),
    );
  }
}

class _ActualizarEstadiaViewContent extends StatefulWidget {
  final Estadia estadia;

  const _ActualizarEstadiaViewContent({Key? key, required this.estadia})
    : super(key: key);

  @override
  State<_ActualizarEstadiaViewContent> createState() =>
      _ActualizarEstadiaViewContentState();
}

class _ActualizarEstadiaViewContentState
    extends State<_ActualizarEstadiaViewContent> {
  final _formKey = GlobalKey<FormState>();
  String get _token => AppProviders.getToken(context);

  // Controladores para los campos del formulario
  late final TextEditingController _alumnoIdController;
  late final TextEditingController _idDocenteController;
  late final TextEditingController _empresaIdController;
  late final TextEditingController _asesorExternoController;
  late final TextEditingController _proyectoNombreController;
  late final TextEditingController _duracionSemanasController;
  late final TextEditingController _apoyoController;

  late DateTime _fechaInicio;
  late DateTime _fechaFin;
  late String _estatus;

  final List<String> _estatusOptions = [
    'solicitada',
    'aceptada',
    'concluida',
    'en revisión',
  ];

  @override
  void initState() {
    super.initState();

    // Inicializar controladores con los datos de la estadía existente
    _alumnoIdController = TextEditingController(
      text: widget.estadia.alumnoId.toString(),
    );
    _idDocenteController = TextEditingController(
      text: widget.estadia.idDocente.toString(),
    );
    _empresaIdController = TextEditingController(
      text: widget.estadia.empresaId.toString(),
    );
    _asesorExternoController = TextEditingController(
      text: widget.estadia.asesorExterno,
    );
    _proyectoNombreController = TextEditingController(
      text: widget.estadia.proyectoNombre,
    );
    _duracionSemanasController = TextEditingController(
      text: widget.estadia.duracionSemanas.toString(),
    );
    _apoyoController = TextEditingController(text: widget.estadia.apoyo);

    // Inicializar fechas y estatus con los datos existentes
    _fechaInicio = widget.estadia.fechaInicio;
    _fechaFin = widget.estadia.fechaFin;
    _estatus = widget.estadia.estatus;
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
    // Restaurar valores originales
    _alumnoIdController.text = widget.estadia.alumnoId.toString();
    _idDocenteController.text = widget.estadia.idDocente.toString();
    _empresaIdController.text = widget.estadia.empresaId.toString();
    _asesorExternoController.text = widget.estadia.asesorExterno;
    _proyectoNombreController.text = widget.estadia.proyectoNombre;
    _duracionSemanasController.text = widget.estadia.duracionSemanas.toString();
    _apoyoController.text = widget.estadia.apoyo;

    setState(() {
      _fechaInicio = widget.estadia.fechaInicio;
      _fechaFin = widget.estadia.fechaFin;
      _estatus = widget.estadia.estatus;
    });

    context.read<ActualizarEstadiaViewModel>().resetState();
  }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<ActualizarEstadiaViewModel>();

      // Crear request para actualizar
      final request = ActualizarEstadiaRequest(
        token: _token,
        id: widget.estadia.id,
        alumnoId: int.parse(_alumnoIdController.text),
        idDocente: int.parse(_idDocenteController.text),
        empresaId: int.parse(_empresaIdController.text),
        asesorExterno: _asesorExternoController.text,
        proyectoNombre: _proyectoNombreController.text,
        duracionSemanas: int.parse(_duracionSemanasController.text),
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        apoyo: _apoyoController.text,
        estatus: _estatus,
      );

      final success = await viewModel.actualizarEstadia(request);

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
          content: const Text('Estadía actualizada correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Opcional: regresar a la pantalla anterior
                // Navigator.of(context).pop(true); // para indicar éxito
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  bool _haCambiadoElFormulario() {
    return _alumnoIdController.text != widget.estadia.alumnoId.toString() ||
        _idDocenteController.text != widget.estadia.idDocente.toString() ||
        _empresaIdController.text != widget.estadia.empresaId.toString() ||
        _asesorExternoController.text != widget.estadia.asesorExterno ||
        _proyectoNombreController.text != widget.estadia.proyectoNombre ||
        _duracionSemanasController.text !=
            widget.estadia.duracionSemanas.toString() ||
        _fechaInicio != widget.estadia.fechaInicio ||
        _fechaFin != widget.estadia.fechaFin ||
        _apoyoController.text != widget.estadia.apoyo ||
        _estatus != widget.estadia.estatus;
  }

  Future<bool> _mostrarDialogoSalir() async {
    if (!_haCambiadoElFormulario()) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambios sin guardar'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Estás seguro de que quieres salir?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _mostrarDialogoSalir,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actualizar Estadía'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: _limpiarFormulario,
              tooltip: 'Restaurar valores originales',
            ),
          ],
        ),
        body: Consumer<ActualizarEstadiaViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Información de la estadía actual
                    _buildInfoEstadia(),
                    const SizedBox(height: 16),

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

                    // Selector de Estatus
                    _buildDropdownEstatus(),
                    const SizedBox(height: 24),

                    // Botón de actualizar
                    _buildSubmitButton(viewModel),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoEstadia() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Editando estadía del alumno ID: ${widget.estadia.alumnoId}',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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

  Widget _buildDropdownEstatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatus',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _estatus,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              items: _estatusOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _estatus = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ActualizarEstadiaViewModel viewModel) {
    final hasChanges = _haCambiadoElFormulario();

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (viewModel.isLoading || !hasChanges)
            ? null
            : _enviarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasChanges ? Colors.orange : Colors.grey,
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.update),
                  const SizedBox(width: 8),
                  Text(
                    hasChanges ? 'Actualizar Estadía' : 'Sin cambios',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
