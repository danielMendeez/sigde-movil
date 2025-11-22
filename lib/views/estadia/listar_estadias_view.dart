import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigde/models/estadia/estadia.dart';
import 'package:sigde/viewmodels/estadia/listar_estadias_viewmodel.dart';
import 'package:sigde/views/estadia/ver_estadia_view.dart';
import 'package:sigde/views/estadia/actualizar_estadia_view.dart';

class ListarEstadiasView extends StatefulWidget {
  final String token;

  const ListarEstadiasView({Key? key, required this.token}) : super(key: key);

  @override
  State<ListarEstadiasView> createState() => _ListarEstadiasViewState();
}

class _ListarEstadiasViewState extends State<ListarEstadiasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListarEstadiasViewModel>().cargarEstadias(widget.token);
    });
  }

  void _editarEstadia(BuildContext context, Estadia estadia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ActualizarEstadiaView(token: widget.token, estadia: estadia),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Estadías'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ListarEstadiasViewModel>().cargarEstadias(
                widget.token,
              );
            },
          ),
        ],
      ),
      body: Consumer<ListarEstadiasViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                    onPressed: () {
                      viewModel.cargarEstadias(widget.token);
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.estadias.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron estadías',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.estadias.length,
            itemBuilder: (context, index) {
              final estadia = viewModel.estadias[index];
              return _EstadiaCard(
                estadia: estadia,
                token: widget.token,
                trailing: IconButton(
                  tooltip: 'Editar estadía',
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editarEstadia(context, estadia),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerEstadiaView(
                        token: widget.token,
                        estadiaId: estadia.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EstadiaCard extends StatelessWidget {
  final Estadia estadia;
  final String token;
  final VoidCallback onTap;
  final Widget? trailing;

  const _EstadiaCard({
    Key? key,
    required this.estadia,
    required this.token,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estadia.proyectoNombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.person,
                    text: 'Asesor: ${estadia.asesorExterno}',
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    text: 'Duración: ${estadia.duracionSemanas} semanas',
                  ),
                  _InfoRow(
                    icon: Icons.date_range,
                    text: 'Inicio: ${_formatDate(estadia.fechaInicio)}',
                  ),
                  _InfoRow(
                    icon: Icons.date_range,
                    text: 'Fin: ${_formatDate(estadia.fechaFin)}',
                  ),
                  _InfoRow(
                    icon: Icons.help_outline,
                    text: 'Apoyo: ${estadia.apoyo}',
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(estadia.estatus),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      estadia.estatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botón de editar en la esquina superior derecha
          if (trailing != null) Positioned(top: 8, right: 8, child: trailing!),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String estatus) {
    switch (estatus.toLowerCase()) {
      case 'solicitada':
        return Colors.blue;
      case 'en revisión':
        return Colors.orange;
      case 'aceptada':
        return Colors.green;
      case 'cancelado':
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
