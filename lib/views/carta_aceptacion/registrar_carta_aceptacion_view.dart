import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/carta_aceptacion/registrar_carta_aceptacion_request.dart';
import 'package:sigde/viewmodels/carta_aceptacion/registrar_carta_aceptacion_viewmodel.dart';
import 'package:provider/provider.dart';

class RegistrarCartaAceptacionView extends StatelessWidget {
  final String token;

  const RegistrarCartaAceptacionView({Key? key, required this.token})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithRegistrarCartaAceptacionProviders(
      token: token,
      child: const _RegistrarCartaAceptacionViewContent(),
    );
  }
}

class _RegistrarCartaAceptacionViewContent extends StatefulWidget {
  const _RegistrarCartaAceptacionViewContent({Key? key}) : super(key: key);

  @override
  State<_RegistrarCartaAceptacionViewContent> createState() =>
      _RegistrarCartaAceptacionViewContentState();
}

class _RegistrarCartaAceptacionViewContentState
    extends State<_RegistrarCartaAceptacionViewContent> {
  String get _token => AppProviders.getToken(context);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _observacionesController =
      TextEditingController();
  DateTime _fechaRecepcion = DateTime.now();
  File? _documentoSeleccionado;
  String? _rutaDocumento;
  int? _selectedEstadiaId;
  String? _nombreDocumento;
  double? _tamanioDocumento;

  // Listas simuladas para los dropdowns (deberías reemplazarlas con tus datos reales)
  final List<Map<String, dynamic>> _estadias = [
    {'id': 1, 'nombre': 'Estadía en Desarrollo Móvil'},
    {'id': 2, 'nombre': 'Estadía en Base de Datos'},
    {'id': 3, 'nombre': 'Estadía en Inteligencia Artificial'},
    {'id': 4, 'nombre': 'Estadía en Redes y Seguridad'},
  ];

  // Formatos de archivo permitidos
  final List<String> _formatosPermitidos = ['pdf', 'doc', 'docx'];
  final Map<String, String> _iconosFormatos = {
    'pdf': 'PDF',
    'doc': 'DOC',
    'docx': 'DOCX',
  };

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  // Método auxiliar para obtener errores de validación del ViewModel
  String? _getValidationError(String fieldName) {
    final viewModel = context.read<RegistrarCartaAceptacionViewModel>();
    return viewModel.getFieldError(fieldName);
  }

  // Método para limpiar errores de un campo específico
  void _limpiarErrorCampo(String fieldName) {
    final viewModel = context.read<RegistrarCartaAceptacionViewModel>();
    viewModel.limpiarErrorCampo(fieldName);
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaRecepcion,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null && fechaSeleccionada != _fechaRecepcion) {
      setState(() {
        _fechaRecepcion = fechaSeleccionada;
      });
    }
  }

  Future<void> _seleccionarDocumento() async {
    try {
      // Limpiar selección previa
      _limpiarSeleccionDocumento();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _formatosPermitidos,
        allowMultiple: false,
        withData: false, // Para archivos grandes, usar withData: false
        withReadStream: false, // Para archivos muy grandes
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Validar el tipo de archivo
        if (!_validarTipoArchivo(file.extension)) {
          _mostrarError(
            'Tipo de archivo no permitido. Formatos aceptados: ${_formatosPermitidos.join(', ').toUpperCase()}',
          );
          return;
        }

        // Validar tamaño del archivo (máximo 10MB)
        if (file.size > 10 * 1024 * 1024) {
          _mostrarError('El archivo es demasiado grande. Tamaño máximo: 10MB');
          return;
        }

        // Si todo está bien, procesar el archivo
        setState(() {
          _documentoSeleccionado = File(file.path!);
          _rutaDocumento = file.path!;
          _nombreDocumento = file.name;
          _tamanioDocumento = file.size / 1024; // Convertir a KB
        });

        // Limpiar error del documento si existe
        _limpiarErrorCampo('ruta_documento');

        _mostrarExito('Documento seleccionado: ${file.name}');
      }
    } on Exception catch (e) {
      _mostrarError('Error al seleccionar documento: $e');
    }
  }

  bool _validarTipoArchivo(String? extension) {
    if (extension == null) return false;
    return _formatosPermitidos.contains(extension.toLowerCase());
  }

  void _limpiarSeleccionDocumento() {
    setState(() {
      _documentoSeleccionado = null;
      _rutaDocumento = null;
      _nombreDocumento = null;
      _tamanioDocumento = null;
    });
  }

  void _registrarCarta() {
    // Limpiar errores previos del ViewModel
    final viewModel = context.read<RegistrarCartaAceptacionViewModel>();
    viewModel.limpiarError();

    if (_formKey.currentState!.validate()) {
      if (_rutaDocumento == null) {
        _mostrarError('Por favor seleccione un documento');
        return;
      }
      if (_selectedEstadiaId == null) {
        _mostrarError('Por favor seleccione una estadía');
        return;
      }
      _enviarFormulario();
    }
  }

  Future<void> _enviarFormulario() async {
    final viewModel = context.read<RegistrarCartaAceptacionViewModel>();

    try {
      final request = RegistrarCartaAceptacionRequest(
        estadiaId: _selectedEstadiaId!,
        fechaRecepcion: _fechaRecepcion,
        rutaDocumento: _nombreDocumento ?? '', // Solo el nombre o vacío
        observaciones: _observacionesController.text,
      );

      final success = await viewModel.registrarCartaAceptacion(
        request,
        _token,
        _documentoSeleccionado, // Pasar el archivo File
      );

      if (success) {
        _mostrarExito('Carta de Aceptación registrada exitosamente');
        _limpiarFormulario();
      } else {
        _mostrarErroresValidacion(viewModel);
      }
    } catch (e) {
      _mostrarError('Error: $e');
    }
  }

  void _mostrarErroresValidacion(RegistrarCartaAceptacionViewModel viewModel) {
    // Mostrar mensaje general si existe
    if (viewModel.errorMessage.isNotEmpty) {
      _mostrarError(viewModel.errorMessage);
    }

    // Forzar rebuild para mostrar errores en los campos
    setState(() {});
  }

  void _limpiarFormulario() {
    _formKey.currentState?.reset();
    final viewModel = context.read<RegistrarCartaAceptacionViewModel>();
    viewModel.resetState();

    setState(() {
      _selectedEstadiaId = null;
      _fechaRecepcion = DateTime.now();
      _documentoSeleccionado = null;
      _rutaDocumento = null;
      _observacionesController.clear();
    });
  }

  void _mostrarExito(String mensaje) {
    Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _mostrarError(String mensaje) {
    Fluttertoast.showToast(
      msg: mensaje,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  String? _validarObservaciones(String? value) {
    // Primero validación local
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese observaciones';
    }
    if (value.length < 10) {
      return 'Las observaciones deben tener al menos 10 caracteres';
    }

    // Si no hay error local, el error del servidor se mostrará en errorText
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Carta de Aceptación'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _limpiarFormulario,
            tooltip: 'Limpiar formulario',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Estadía
              _buildDropdownEstadia(),

              const SizedBox(height: 20),

              // Campo de fecha de recepción
              _buildFechaRecepcion(),

              const SizedBox(height: 20),

              // Selección de documento
              _buildSelectorDocumento(),

              const SizedBox(height: 20),

              // Campo de observaciones
              _buildCampoObservaciones(),

              const SizedBox(height: 32),

              // Botón de registro
              _buildBotonRegistro(),

              const SizedBox(height: 20),

              // Información adicional
              _buildInformacionAdicional(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownEstadia() {
    final error = _getValidationError('estadia_id');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadía *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Selecciona una estadía',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            errorText: error,
          ),
          value: _selectedEstadiaId,
          items: _estadias.map((item) {
            return DropdownMenuItem<int>(
              value: item['id'],
              child: Text(item['nombre'], style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedEstadiaId = value;
            });
            // Limpiar error del campo cuando se selecciona una opción
            if (value != null) {
              _limpiarErrorCampo('estadia_id');
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona una estadía';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFechaRecepcion() {
    final error = _getValidationError('fecha_recepcion');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Recepción *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        InkWell(
          onTap: _seleccionarFecha,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: error != null ? Colors.red : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_fechaRecepcion.day.toString().padLeft(2, '0')}/'
                  '${_fechaRecepcion.month.toString().padLeft(2, '0')}/'
                  '${_fechaRecepcion.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: error != null ? Colors.red : Colors.black,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: error != null ? Colors.red : Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorDocumento() {
    final error = _getValidationError('ruta_documento');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Documento *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ElevatedButton.icon(
          onPressed: _seleccionarDocumento,
          icon: const Icon(Icons.attach_file),
          label: const Text('Seleccionar Documento'),
          style: ElevatedButton.styleFrom(
            backgroundColor: error != null ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        if (_rutaDocumento != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: error != null ? Colors.red.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: error != null
                    ? Colors.red.shade200
                    : Colors.green.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: error != null ? Colors.red : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Documento seleccionado: ${_rutaDocumento!.split('/').last}',
                    style: TextStyle(
                      color: error != null
                          ? Colors.red.shade800
                          : Colors.green.shade800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCampoObservaciones() {
    final error = _getValidationError('observaciones');

    return TextFormField(
      controller: _observacionesController,
      decoration: InputDecoration(
        labelText: 'Observaciones *',
        border: const OutlineInputBorder(),
        hintText:
            'Ingrese observaciones adicionales sobre la carta de aceptación...',
        alignLabelWithHint: true,
        errorText: error,
      ),
      maxLines: 4,
      onChanged: (value) {
        // Limpiar error del campo cuando el usuario empiece a escribir
        if (error != null && value.isNotEmpty) {
          _limpiarErrorCampo('observaciones');
        }
      },
      validator: _validarObservaciones,
    );
  }

  Widget _buildBotonRegistro() {
    return Consumer<RegistrarCartaAceptacionViewModel>(
      builder: (context, viewModel, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: viewModel.isLoading ? null : _registrarCarta,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Registrar Carta de Aceptación',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInformacionAdicional() {
    return Card(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información adicional',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha de registro: ${DateTime.now().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'Formatos soportados: PDF, DOC, DOCX',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'Todos los campos marcados con * son obligatorios',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
