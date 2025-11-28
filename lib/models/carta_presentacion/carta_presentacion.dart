import 'package:sigde/models/estadia/estadia.dart';

class CartaPresentacion {
  final int id;
  final int estadiaId;
  final int directorId;
  final DateTime fechaEmision;
  final String rutaDocumento;
  final int firmadaDirector;
  final DateTime createdAt;
  final DateTime updatedAt;

  // NUEVO: objeto estadia completo
  final Estadia? estadia;

  CartaPresentacion({
    required this.id,
    required this.estadiaId,
    required this.directorId,
    required this.fechaEmision,
    required this.rutaDocumento,
    required this.firmadaDirector,
    required this.createdAt,
    required this.updatedAt,
    this.estadia,
  });

  factory CartaPresentacion.fromJson(Map<String, dynamic> json) {
    return CartaPresentacion(
      id: json['id'] ?? 0,
      estadiaId: json['estadia_id'] ?? 0,
      directorId: json['director_id'] ?? 0,
      fechaEmision: DateTime.parse(
        json['fecha_emision'] ?? DateTime.now().toIso8601String(),
      ),
      rutaDocumento: json['ruta_documento']?.toString() ?? '',
      firmadaDirector: json['firmada_director'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),

      // Leer la estadia anidada si viene
      estadia: json['estadia'] != null
          ? Estadia.fromJson(json['estadia'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estadia_id': estadiaId,
      'director_id': directorId,
      'fecha_emision': fechaEmision.toIso8601String(),
      'ruta_documento': rutaDocumento,
      'firmada_director': firmadaDirector,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
