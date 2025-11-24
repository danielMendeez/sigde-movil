import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/viewmodels/estadia/ver_estadia_viewmodel.dart';
import 'package:sigde/utils/provider_helpers.dart';
import 'package:sigde/views/estadia/actualizar_estadia_view.dart';

class VerEstadiaView extends StatelessWidget {
  final String token;
  final Estadia estadiaId;

  const VerEstadiaView({Key? key, required this.token, required this.estadiaId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppProviders.wrapWithVerEditarEstadiaProviders(
      token: token,
      child: _VerEstadiaViewContent(estadiaId: estadiaId.id),
    );
  }
}

class _VerEstadiaViewContent extends StatefulWidget {
  final int estadiaId;

  const _VerEstadiaViewContent({Key? key, required this.estadiaId})
    : super(key: key);

  @override
  State<_VerEstadiaViewContent> createState() => _VerEstadiaViewContentState();
}

class _VerEstadiaViewContentState extends State<_VerEstadiaViewContent> {
  String get _token => AppProviders.getToken(context);

  @override
  void initState() {
    super.initState();

    // Esperar a que el widget esté completamente construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEstadiaInicial();
    });
  }

  void _cargarEstadiaInicial() {
    final viewModel = Provider.of<VerEstadiaViewModel>(context, listen: false);
    viewModel.cargarEstadia(_token, widget.estadiaId);
  }

  void _recargarEstadia() {
    final viewModel = Provider.of<VerEstadiaViewModel>(context, listen: false);
    viewModel.cargarEstadia(_token, widget.estadiaId);
  }

  void _editarEstadia() {
    final viewModel = Provider.of<VerEstadiaViewModel>(context, listen: false);
    final estadia = viewModel.estadia;
    if (estadia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró la estadía para editar.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ActualizarEstadiaView(token: _token, estadia: estadia),
      ),
    ).then((_) {
      _recargarEstadia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Estadía'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recargarEstadia,
            tooltip: 'Recargar',
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editarEstadia,
            tooltip: 'Editar Estadía',
          ),
        ],
      ),
      body: Consumer<VerEstadiaViewModel>(
        builder: (context, viewModel, child) {
          return _buildBody(viewModel);
        },
      ),
    );
  }

  Widget _buildBody(VerEstadiaViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando información de la estadía...'),
          ],
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Error: ${viewModel.errorMessage}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _recargarEstadia,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasData) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No se encontró la estadía',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _EstadiaDetalleWidget(estadia: viewModel.estadia!);
  }
}

class _EstadiaDetalleWidget extends StatelessWidget {
  final Estadia estadia;

  const _EstadiaDetalleWidget({Key? key, required this.estadia})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre del proyecto
          _buildHeader(),
          const SizedBox(height: 24),

          // Información básica
          _buildSeccion(
            titulo: 'Información General',
            children: [
              _InfoItem(
                icon: Icons.person,
                label: 'ID Alumno:',
                valor: estadia.alumnoId.toString(),
              ),
              _InfoItem(
                icon: Icons.school,
                label: 'ID Docente:',
                valor: estadia.idDocente.toString(),
              ),
              _InfoItem(
                icon: Icons.business,
                label: 'ID Empresa:',
                valor: estadia.empresaId.toString(),
              ),
              _InfoItem(
                icon: Icons.supervisor_account,
                label: 'Asesor Externo:',
                valor: estadia.asesorExterno,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Detalles del proyecto
          _buildSeccion(
            titulo: 'Detalles del Proyecto',
            children: [
              _InfoItem(
                icon: Icons.assignment,
                label: 'Proyecto:',
                valor: estadia.proyectoNombre,
                multilinea: true,
              ),
              _InfoItem(
                icon: Icons.timeline,
                label: 'Duración:',
                valor: '${estadia.duracionSemanas} semanas',
              ),
              _InfoItem(
                icon: Icons.help_outline,
                label: 'Apoyo:',
                valor: estadia.apoyo,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Fechas
          _buildSeccion(
            titulo: 'Fechas',
            children: [
              _InfoItem(
                icon: Icons.calendar_today,
                label: 'Fecha Inicio:',
                valor: _formatDate(estadia.fechaInicio),
              ),
              _InfoItem(
                icon: Icons.event_available,
                label: 'Fecha Fin:',
                valor: _formatDate(estadia.fechaFin),
              ),
              _InfoItem(
                icon: Icons.schedule,
                label: 'Días restantes:',
                valor: _calcularDiasRestantes(estadia.fechaFin),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Metadatos
          _buildSeccion(
            titulo: 'Información Adicional',
            children: [
              _InfoItem(
                icon: Icons.create,
                label: 'Creado:',
                valor: _formatDateTime(estadia.createdAt),
              ),
              _InfoItem(
                icon: Icons.update,
                label: 'Actualizado:',
                valor: _formatDateTime(estadia.updatedAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    estadia.proyectoNombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                _buildEstatusChip(estadia.estatus),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${estadia.id}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildEstatusChip(String estatus) {
    final Color color;
    switch (estatus.toLowerCase()) {
      case 'activo':
        color = Colors.green;
      case 'solicitada':
        color = Colors.orange;
      case 'completado':
        color = Colors.blue;
      case 'cancelado':
        color = Colors.red;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        estatus.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _calcularDiasRestantes(DateTime fechaFin) {
    final now = DateTime.now();
    final diferencia = fechaFin.difference(now);

    if (diferencia.inDays < 0) {
      return 'Finalizada (${diferencia.inDays.abs()} días atrás)';
    } else if (diferencia.inDays == 0) {
      return 'Finaliza hoy';
    } else {
      return '${diferencia.inDays} días';
    }
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final bool multilinea;

  const _InfoItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.valor,
    this.multilinea = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: multilinea
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: multilinea ? 1.3 : 1.0,
                  ),
                  maxLines: multilinea ? null : 1,
                  overflow: multilinea ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
