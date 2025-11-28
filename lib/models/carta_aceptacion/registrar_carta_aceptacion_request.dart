class RegistrarCartaAceptacionRequest {
  final int estadiaId;
  final DateTime fechaRecepcion;
  final String rutaDocumento;
  final String observaciones;

  RegistrarCartaAceptacionRequest({
    required this.estadiaId,
    required this.fechaRecepcion,
    required this.rutaDocumento,
    required this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'estadia_id': estadiaId,
      'fecha_recepcion': fechaRecepcion.toIso8601String(),
      'ruta_documento': rutaDocumento,
      'observaciones': observaciones,
    };
  }
}
