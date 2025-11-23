import 'package:flutter/material.dart';

class ConfirmarEliminacionDialog extends StatelessWidget {
  final String titulo;
  final String mensaje;
  final Function() onConfirmar;

  const ConfirmarEliminacionDialog({
    Key? key,
    required this.titulo,
    required this.mensaje,
    required this.onConfirmar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning, color: Colors.yellow),
          const SizedBox(width: 8),
          Text(titulo),
        ],
      ),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirmar();
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
