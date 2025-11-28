import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/carta_presentacion/registrar_carta_presentacion_request.dart';
import 'package:sigde/viewmodels/carta_presentacion/registrar_carta_presentacion_viewmodel.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _tutorIdController = TextEditingController();

  // Listas simuladas para los dropdowns (deberías reemplazarlas con tus datos reales)
  final List<Map<String, dynamic>> _estadias = [
    {'id': 1, 'nombre': 'Estadía en Desarrollo Móvil'},
    {'id': 2, 'nombre': 'Estadía en Base de Datos'},
    {'id': 3, 'nombre': 'Estadía en Inteligencia Artificial'},
    {'id': 4, 'nombre': 'Estadía en Redes y Seguridad'},
  ];

  final List<Map<String, dynamic>> _tutores = [
    {'id': 1, 'nombre': 'Dr. Juan Pérez'},
    {'id': 2, 'nombre': 'Dra. María García'},
    {'id': 3, 'nombre': 'Mtro. Carlos López'},
    {'id': 4, 'nombre': 'Ing. Ana Martínez'},
  ];

  @override
  void dispose() {
    _estadiaIdController.dispose();
    _tutorIdController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _estadiaIdController.clear();
    _tutorIdController.clear();
  }

  // Future<void> _seleccionarDocumento() async {
  //   // Aquí implementarías la lógica para seleccionar un archivo
  //   // Por ejemplo, usando file_picker o image_picker
  //   // Por ahora simulamos la selección
  //   setState(() {
  //     _documentoSeleccionado =
  //         'carta_presentacion_${DateTime.now().millisecondsSinceEpoch}.pdf';
  //     _rutaDocumentoController.text = _documentoSeleccionado!;
  //   });
  // }

  void _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<RegistrarCartaPresentacionViewModel>();

      final request = RegistrarCartaPresentacionRequest(
        estadiaId: int.parse(_estadiaIdController.text),
        tutorId: int.parse(_tutorIdController.text),
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
              _buildDropdownFormField(
                label: 'Estadía',
                controller: _estadiaIdController,
                items: _estadias,
                hint: 'Selecciona una estadía',
              ),

              const SizedBox(height: 16),

              // Selector de Tutor
              _buildDropdownFormField(
                label: 'Tutor',
                controller: _tutorIdController,
                items: _tutores,
                hint: 'Selecciona un tutor',
              ),

              const SizedBox(height: 16),

              // // Selector de Fecha
              // _buildDatePickerField(),

              // const SizedBox(height: 16),

              // // Checkbox para firma del director
              // _buildCheckboxField(),

              // const SizedBox(height: 16),

              // // Selector de documento
              // _buildDocumentPickerField(),

              // const SizedBox(height: 32),

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

  // Widget _buildDatePickerField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Fecha de Emisión',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       const SizedBox(height: 8),
  //       InkWell(
  //         onTap: () => _seleccionarFecha(context),
  //         child: InputDecorator(
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             suffixIcon: const Icon(Icons.calendar_today),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 DateFormat('dd/MM/yyyy').format(_fechaEmision),
  //                 style: const TextStyle(fontSize: 16),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildCheckboxField() {
  //   return Row(
  //     children: [
  //       Checkbox(
  //         value: _firmadaDirector == 1,
  //         onChanged: (value) {
  //           setState(() {
  //             _firmadaDirector = value! ? 1 : 0;
  //           });
  //         },
  //       ),
  //       const Expanded(
  //         child: Text(
  //           'Firmada por el Director',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDocumentPickerField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Documento',
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //       ),
  //       const SizedBox(height: 8),
  //       TextFormField(
  //         controller: _rutaDocumentoController,
  //         readOnly: true,
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //           hintText: 'Selecciona un documento',
  //           suffixIcon: IconButton(
  //             icon: const Icon(Icons.attach_file),
  //             onPressed: _seleccionarDocumento,
  //           ),
  //         ),
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Por favor selecciona un documento';
  //           }
  //           return null;
  //         },
  //       ),
  //       if (_documentoSeleccionado != null) ...[
  //         const SizedBox(height: 8),
  //         Text(
  //           'Documento seleccionado: $_documentoSeleccionado',
  //           style: const TextStyle(fontSize: 14, color: Colors.green),
  //         ),
  //       ],
  //     ],
  //   );
  // }

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
