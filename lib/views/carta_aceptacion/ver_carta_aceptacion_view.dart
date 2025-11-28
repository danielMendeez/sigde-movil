import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/viewmodels/carta_aceptacion/ver_carta_aceptacion_viewmodel.dart';
import 'package:file_saver/file_saver.dart';

class VerCartaAceptacionView extends StatelessWidget {
  final String token;
  final CartaAceptacion cartaId;

  const VerCartaAceptacionView({
    Key? key,
    required this.token,
    required this.cartaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithVerCartaAceptacionProviders(
      token: token,
      child: _VerCartaAceptacionViewContent(carta: cartaId),
    );
  }
}

class _VerCartaAceptacionViewContent extends StatefulWidget {
  final CartaAceptacion carta;

  const _VerCartaAceptacionViewContent({Key? key, required this.carta})
    : super(key: key);

  @override
  State<_VerCartaAceptacionViewContent> createState() =>
      _VerCartaAceptacionViewContentState();
}

class _VerCartaAceptacionViewContentState
    extends State<_VerCartaAceptacionViewContent> {
  String get _token => AppProviders.getToken(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCartaInicial();
    });
  }

  void _cargarCartaInicial() {
    final viewModel = Provider.of<VerCartaAceptacionViewModel>(
      context,
      listen: false,
    );
    viewModel.cargarCartaAceptacion(_token, widget.carta.id);
  }

  void _editarCarta() {
    // Navegar a vista de edición
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ActualizarCartaPresentacionView(
    //       token: _token,
    //       carta: widget.carta,
    //     ),
    //   ),
    // );
  }

  void _recargar() {
    final viewModel = Provider.of<VerCartaAceptacionViewModel>(
      context,
      listen: false,
    );
    viewModel.cargarCartaAceptacion(_token, widget.carta.id);
  }

  void _descargarPDF() async {
    // try {
    //   final viewModel = Provider.of<DescargarCartaAceptacionViewModel>(
    //     context,
    //     listen: false,
    //   );

    //   final bytes = await viewModel.descargarCartaAceptacion(
    //     widget.carta.id,
    //     _token,
    //   );

    //   if (bytes.isEmpty) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Error al descargar el PDF')),
    //     );
    //     return;
    //   }

    //   // Guardar archivo usando FileSaver
    //   final path = await FileSaver.instance.saveFile(
    //     name: "carta_${widget.carta.id}",
    //     bytes: bytes,
    //     fileExtension: "pdf",
    //     mimeType: MimeType.pdf,
    //   );

    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("PDF guardado en: $path")));
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("Error: $e")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VerCartaAceptacionViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Carta de Aceptación'),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editarCarta,
                tooltip: 'Editar carta',
              ),
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: _descargarPDF,
                tooltip: 'Descargar PDF',
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _recargar,
                tooltip: 'Recargar carta',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta de información principal
                _buildInfoCard(),
                const SizedBox(height: 20),

                // Sección de documento PDF
                _buildDocumentoSection(),
                const SizedBox(height: 20),

                // Botones de acción
                _buildActionButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de la Carta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('ID de la Carta', widget.carta.id.toString()),
            _buildInfoRow('ID de Estadía', widget.carta.estadiaId.toString()),
            _buildInfoRow(
              'Fecha de Recepción',
              _formatDate(widget.carta.fechaRecepcion),
            ),
            _buildInfoRow('Ruta del Documento', widget.carta.rutaDocumento),
            _buildInfoRow('Observaciones', widget.carta.observaciones),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentoSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Documento PDF',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.carta.rutaDocumento.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Archivo: ${widget.carta.rutaDocumento.split('/').last}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Ruta: ${widget.carta.rutaDocumento}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _descargarPDF,
                  icon: const Icon(Icons.visibility),
                  label: const Text('Ver Documento'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else ...[
              const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No hay documento PDF asociado',
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _editarCarta,
            icon: const Icon(Icons.edit),
            label: const Text('Editar Carta'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getColorEstadoFirma(int estado) {
    switch (estado) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconEstadoFirma(int estado) {
    switch (estado) {
      case 1:
        return Icons.check_circle;
      case 0:
        return Icons.pending_actions;
      default:
        return Icons.help_outline;
    }
  }

  String _getTextoEstadoFirma(int estado) {
    switch (estado) {
      case 1:
        return 'FIRMADA';
      case 0:
        return 'PENDIENTE DE FIRMA';
      default:
        return 'ESTADO DESCONOCIDO';
    }
  }

  String _getDescripcionEstadoFirma(int estado) {
    switch (estado) {
      case 1:
        return 'El director ha firmado esta carta de presentación';
      case 0:
        return 'Esperando la firma del director';
      default:
        return 'Estado no reconocido';
    }
  }
}
