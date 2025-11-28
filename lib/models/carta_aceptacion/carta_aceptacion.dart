class CartaAceptacion {
  final int id;
  final int estadiaId;
  final DateTime fechaRecepcion;
  final String rutaDocumento;
  final String observaciones;

  CartaAceptacion({
    required this.id,
    required this.estadiaId,
    required this.fechaRecepcion,
    required this.rutaDocumento,
    required this.observaciones,
  });

  factory CartaAceptacion.fromJson(Map<String, dynamic> json) {
    return CartaAceptacion(
      id: json['id'] ?? 0,
      estadiaId: json['estadia_id'] ?? 0,
      fechaRecepcion: DateTime.parse(
        json['fecha_recepcion'] ?? DateTime.now().toIso8601String(),
      ),
      rutaDocumento: json['ruta_documento'] ?? '',
      observaciones: json['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estadia_id': estadiaId,
      'fecha_recepcion': fechaRecepcion.toIso8601String(),
      'ruta_documento': rutaDocumento,
      'observaciones': observaciones,
    };
  }
}
