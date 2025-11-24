class CartaPresentacion {
  final int id;
  final int estadiaId;
  final int tutorId;
  final DateTime fechaEmision;
  final String rutaDocumento;
  final String textoAdicional;
  final int firmadaDirector;

  CartaPresentacion({
    required this.id,
    required this.estadiaId,
    required this.tutorId,
    required this.fechaEmision,
    required this.rutaDocumento,
    required this.textoAdicional,
    required this.firmadaDirector,
  });

  factory CartaPresentacion.fromJson(Map<String, dynamic> json) {
    return CartaPresentacion(
      id: json['id'] ?? 0,
      estadiaId: json['estadia_id'] ?? 0,
      tutorId: json['tutor_id'] ?? 0,
      fechaEmision: DateTime.parse(
        json['fecha_emision'] ?? DateTime.now().toIso8601String(),
      ),
      rutaDocumento: json['ruta_documento'] ?? '',
      textoAdicional: json['texto_adicional'] ?? '',
      firmadaDirector: json['firmada_director'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estadia_id': estadiaId,
      'tutor_id': tutorId,
      'fecha_emision': fechaEmision.toIso8601String(),
      'ruta_documento': rutaDocumento,
      'texto_adicional': textoAdicional,
      'firmada_director': firmadaDirector,
    };
  }
}
