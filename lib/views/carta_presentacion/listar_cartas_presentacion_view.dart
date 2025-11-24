import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/models/carta_presentacion/carta_presentacion.dart';
import 'package:sigde/viewmodels/carta_presentacion/listar_cartas_presentacion_viewmodel.dart';
import 'package:sigde/views/carta_presentacion/ver_carta_presentacion_view.dart';

class ListarCartasPresentacionView extends StatelessWidget {
  final String token;

  const ListarCartasPresentacionView({Key? key, required this.token})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithListarCartasPresentacionProviders(
      token: token,
      child: const _ListarCartasPresentacionViewContent(),
    );
  }
}

class _ListarCartasPresentacionViewContent extends StatefulWidget {
  const _ListarCartasPresentacionViewContent({Key? key}) : super(key: key);

  @override
  State<_ListarCartasPresentacionViewContent> createState() =>
      _ListarCartasPresentacionViewContentState();
}

class _ListarCartasPresentacionViewContentState
    extends State<_ListarCartasPresentacionViewContent> {
  String get _token => AppProviders.getToken(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ListarCartasPresentacionViewModel>()
          .cargarCartasPresentacion(_token);
    });
  }

  void _recargarCartas() {
    context.read<ListarCartasPresentacionViewModel>().cargarCartasPresentacion(
      _token,
    );
  }

  void _verDetalleCarta(BuildContext context, CartaPresentacion carta) {
    // Navegar a vista de detalle
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VerCartaPresentacionView(token: _token, cartaId: carta),
      ),
    );
  }

  void _editarCarta(BuildContext context, CartaPresentacion carta) {
    // Navegar a vista de edición (implementar después)
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ActualizarCartaPresentacionView(
    //       token: _token,
    //       carta: carta,
    //     ),
    //   ),
    // );
  }

  void _eliminarCarta(BuildContext context, CartaPresentacion carta) {
    // Implementar eliminación de carta (después)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartas de Presentación'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargarCartas,
            tooltip: 'Refrescar lista',
          ),
        ],
      ),
      body: Consumer<ListarCartasPresentacionViewModel>(
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
          if (viewModel.cartasPresentacion.isEmpty) {
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
                    'No se encontraron cartas de presentación',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Token: ${_token.substring(0, 10)}...', // Para debug
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Estado con datos
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.cartasPresentacion.length,
            itemBuilder: (context, index) {
              final carta = viewModel.cartasPresentacion[index];
              return _CartaPresentacionCard(
                carta: carta,
                onTap: () => _verDetalleCarta(context, carta),
                onEdit: () => _editarCarta(context, carta),
                onDelete: () => _eliminarCarta(context, carta),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a vista de registrar carta (implementar después)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RegistrarCartaPresentacionView(
          //       token: _token,
          //     ),
          //   ),
          // );
        },
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Registrar nueva carta',
      ),
    );
  }
}

class _CartaPresentacionCard extends StatelessWidget {
  final CartaPresentacion carta;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CartaPresentacionCard({
    Key? key,
    required this.carta,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
              // Header con ID de estadía y botón de editar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Estadía ID: ${carta.estadiaId}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.purple),
                    onPressed: onEdit,
                    tooltip: 'Editar carta',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Eliminar carta',
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Información de la carta
              _InfoRow(icon: Icons.person, text: 'Tutor ID: ${carta.tutorId}'),
              _InfoRow(
                icon: Icons.school,
                text: 'Firma de director: ${carta.firmadaDirector}',
              ),
              _InfoRow(
                icon: Icons.date_range,
                text:
                    'Fecha de emisión: ${carta.fechaEmision.toLocal().toIso8601String().split('T').first}',
              ),

              // Texto adicional (si existe)
              if (carta.textoAdicional.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Texto adicional: ${carta.textoAdicional}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Ruta del PDF y estado de firma
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.picture_as_pdf, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      carta.rutaDocumento.isNotEmpty
                          ? 'PDF: ${carta.rutaDocumento.split('/').last}'
                          : 'Sin PDF',
                      style: TextStyle(
                        fontSize: 14,
                        color: carta.rutaDocumento.isNotEmpty
                            ? Colors.black87
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              // Estado de firma
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getColorEstadoFirma(carta.firmadaDirector),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorEstadoFirma(int estado) {
    switch (estado) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.orange;
      case -1:
        return Colors.red;
      default:
        return Colors.grey;
    }
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
      padding: const EdgeInsets.only(bottom: 4),
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
