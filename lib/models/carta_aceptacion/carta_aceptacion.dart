class CartaAceptacion {
  final int id;
  final int estadiaId;
  final String rutaDocumento;
  final DateTime fechaRecepcion;
  final String observaciones;

  CartaAceptacion({
    required this.id,
    required this.estadiaId,
    required this.rutaDocumento,
    required this.fechaRecepcion,
    required this.observaciones,
  });

  factory CartaAceptacion.fromJson(Map<String, dynamic> json) {
    return CartaAceptacion(
      id: json['id'] ?? 0,
      estadiaId: json['estadia_id'] ?? 0,
      rutaDocumento: json['ruta_documento'] ?? '',
      fechaRecepcion: DateTime.parse(
        json['fecha_recepcion'] ?? DateTime.now().toIso8601String(),
      ),
      observaciones: json['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estadia_id': estadiaId,
      'ruta_documento': rutaDocumento,
      'fecha_recepcion': fechaRecepcion.toIso8601String(),
      'observaciones': observaciones,
    };
  }
}
