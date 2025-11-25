import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/carta_aceptacion/carta_aceptacion.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/viewmodels/carta_aceptacion/listar_cartas_aceptacion_viewmodel.dart';

class ListarCartasAceptacionView extends StatelessWidget {
  final String token;

  const ListarCartasAceptacionView({Key? key, required this.token})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithListarCartasAceptacionProviders(
      token: token,
      child: const _ListarCartasAceptacionViewContent(),
    );
  }
}

class _ListarCartasAceptacionViewContent extends StatefulWidget {
  const _ListarCartasAceptacionViewContent({Key? key}) : super(key: key);

  @override
  State<_ListarCartasAceptacionViewContent> createState() =>
      _ListarCartasAceptacionViewContentState();
}

class _ListarCartasAceptacionViewContentState
    extends State<_ListarCartasAceptacionViewContent> {
  String get _token => AppProviders.getToken(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListarCartasAceptacionViewModel>().cargarCartasAceptacion(
        _token,
      );
    });
  }

  void _recargarCartas() {
    context.read<ListarCartasAceptacionViewModel>().cargarCartasAceptacion(
      _token,
    );
  }

  void _verDetalleCarta(BuildContext context, CartaAceptacion carta) {
    // Navegar a vista de detalle
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VerCartaAceptacionView(
    //       token: _token,
    //       carta: carta,
    //     ),
    //   ),
    // );
  }

  void _editarCarta(BuildContext context, CartaAceptacion carta) {
    // Navegar a vista de edición
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ActualizarCartaAceptacionView(
    //       token: _token,
    //       carta: carta,
    //     ),
    //   ),
    // );
  }

  void _descargarPDF(CartaAceptacion carta) {
    if (carta.rutaDocumento.isNotEmpty) {
      // Lógica para descargar/ver el PDF
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Descargando PDF: ${carta.rutaDocumento}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay PDF disponible para descargar'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartas de Aceptación'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargarCartas,
            tooltip: 'Recargar cartas',
          ),
        ],
      ),
      body: Consumer<ListarCartasAceptacionViewModel>(
        builder: (context, viewModel, child) {
          // Estado de carga
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de error
          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _recargarCartas,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Estado vacío
          if (viewModel.cartasAceptacion.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No se encontraron cartas de aceptación',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Token: ${_token.substring(0, 10)}...',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Estado con datos
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.cartasAceptacion.length,
            itemBuilder: (context, index) {
              final carta = viewModel.cartasAceptacion[index];
              return _CartaAceptacionCard(
                carta: carta,
                onTap: () => _verDetalleCarta(context, carta),
                onEdit: () => _editarCarta(context, carta),
                onDownload: () => _descargarPDF(carta),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a vista de registrar carta
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RegistrarCartaAceptacionView(
          //       token: _token,
          //     ),
          //   ),
          // );
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CartaAceptacionCard extends StatelessWidget {
  final CartaAceptacion carta;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDownload;

  const _CartaAceptacionCard({
    Key? key,
    required this.carta,
    required this.onTap,
    required this.onEdit,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con ID de carta y botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Carta de Aceptación #${carta.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.teal),
                        onPressed: onDownload,
                        tooltip: 'Descargar PDF',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        onPressed: onEdit,
                        tooltip: 'Editar carta',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Información principal de la carta
              _InfoRow(
                icon: Icons.business_center,
                text: 'Estadía ID: ${carta.estadiaId}',
              ),

              _InfoRow(
                icon: Icons.calendar_today,
                text: 'Fecha Recepción: ${_formatDate(carta.fechaRecepcion)}',
              ),

              // Observaciones (si existen)
              if (carta.observaciones.isNotEmpty) ...[
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observaciones:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      carta.observaciones,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],

              // Estado del documento PDF
              const SizedBox(height: 8),
              _buildEstadoDocumento(),

              // Información adicional
              const SizedBox(height: 8),
              _buildInfoAdicional(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoDocumento() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            carta.rutaDocumento.isNotEmpty ? Icons.check_circle : Icons.pending,
            color: carta.rutaDocumento.isNotEmpty
                ? Colors.green
                : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carta.rutaDocumento.isNotEmpty
                      ? 'Documento disponible'
                      : 'Documento pendiente',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: carta.rutaDocumento.isNotEmpty
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                if (carta.rutaDocumento.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Archivo: ${carta.rutaDocumento.split('/').last}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoAdicional() {
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.numbers,
          text: 'ID: ${carta.id}',
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        _buildInfoChip(
          icon: Icons.folder_open,
          text: 'Estadía: ${carta.estadiaId}',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({Key? key, required this.icon, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
