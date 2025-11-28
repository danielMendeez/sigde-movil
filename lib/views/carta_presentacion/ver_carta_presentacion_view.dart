import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/viewmodels/carta_presentacion/descargar_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/ver_carta_presentacion_viewmodel.dart';
import 'package:sigde/viewmodels/carta_presentacion/firmar_carta_presentacion_viewmodel.dart';
import 'package:file_saver/file_saver.dart';

class VerCartaPresentacionView extends StatelessWidget {
  final String token;
  final CartaPresentacion cartaId;

  const VerCartaPresentacionView({
    Key? key,
    required this.token,
    required this.cartaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithVerFirmarEditarCartaPresentacionProviders(
      token: token,
      child: _VerCartaPresentacionViewContent(carta: cartaId),
    );
  }
}

class _VerCartaPresentacionViewContent extends StatefulWidget {
  final CartaPresentacion carta;

  const _VerCartaPresentacionViewContent({Key? key, required this.carta})
    : super(key: key);

  @override
  State<_VerCartaPresentacionViewContent> createState() =>
      _VerCartaPresentacionViewContentState();
}

class _VerCartaPresentacionViewContentState
    extends State<_VerCartaPresentacionViewContent> {
  String get _token => AppProviders.getToken(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCartaInicial();
    });
  }

  void _cargarCartaInicial() {
    final viewModel = Provider.of<VerCartaPresentacionViewModel>(
      context,
      listen: false,
    );
    viewModel.cargarCartaPresentacion(_token, widget.carta.id);
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
    final viewModel = Provider.of<VerCartaPresentacionViewModel>(
      context,
      listen: false,
    );
    viewModel.cargarCartaPresentacion(_token, widget.carta.id);
  }

  void _descargarPDF() async {
    try {
      final viewModel = Provider.of<DescargarCartaPresentacionViewModel>(
        context,
        listen: false,
      );

      final bytes = await viewModel.descargarCartaPresentacion(
        widget.carta.id,
        _token,
      );

      if (bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al descargar el PDF')),
        );
        return;
      }

      // Guardar archivo usando FileSaver
      final path = await FileSaver.instance.saveFile(
        name: "carta_${widget.carta.id}",
        bytes: bytes,
        fileExtension: "pdf",
        mimeType: MimeType.pdf,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("PDF guardado en: $path")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _firmarCarta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firmar Carta de Presentación'),
        content: const Text(
          '¿Deseas firmar la carta de presentación como director?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _procesarFirmaCarta();
            },
            child: const Text('Firmar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _procesarFirmaCarta() async {
    final firmarViewModel = context.read<FirmarCartaPresentacionViewModel>();
    await firmarViewModel.firmarCartaPresentacion(_token, widget.carta.id);

    if (!firmarViewModel.hasError) {
      _mensajeFirmaExitosa();
    } else if (firmarViewModel.hasError) {
      Fluttertoast.showToast(
        msg: "Error al firmar la carta: ${firmarViewModel.errorMessage}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print(
        'Error al firmar la carta de presentación: ${firmarViewModel.errorMessage}',
      );
    }
  }

  void _mensajeFirmaExitosa() {
    Fluttertoast.showToast(
      msg: "La carta de presentación ha sido firmada exitosamente.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VerCartaPresentacionViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Carta de Presentación'),
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

                // Sección de estado de firma
                _buildEstadoFirmaSection(),
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
            _buildInfoRow('Carta', widget.carta.id.toString()),
            _buildInfoRow(
              'Estadía',
              widget.carta.estadia?.proyectoNombre ?? 'Sin estadía',
            ),
            _buildInfoRow(
              'Empresa',
              widget.carta.estadia?.empresa?.nombre ?? 'Sin empresa',
            ),
            _buildInfoRow(
              'Fecha de Emisión',
              _formatDate(widget.carta.fechaEmision),
            ),
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

  Widget _buildEstadoFirmaSection() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de Firma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getColorEstadoFirma(widget.carta.firmadaDirector),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getIconEstadoFirma(widget.carta.firmadaDirector),
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTextoEstadoFirma(widget.carta.firmadaDirector),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getDescripcionEstadoFirma(
                            widget.carta.firmadaDirector,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
        const SizedBox(width: 12),
        if (widget.carta.firmadaDirector == 0) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _firmarCarta,
              icon: const Icon(Icons.draw),
              label: const Text('Firmar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
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
