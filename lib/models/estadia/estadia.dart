import 'package:sigde/models/user/user.dart';
import 'package:sigde/models/carrera/carrera.dart';
import 'package:sigde/models/empresa/empresa.dart';

class Estadia {
  final int id;
  final int alumnoId;
  final int empresaId;
  final int carreraId;
  final int tutorId;
  final String asesorExterno;
  final String proyectoNombre;
  final int duracionSemanas;
  final int apoyo;
  final String estatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? alumno;
  final Empresa? empresa;
  final Carrera? carrera;

  Estadia({
    required this.id,
    required this.alumnoId,
    required this.empresaId,
    required this.carreraId,
    required this.tutorId,
    required this.asesorExterno,
    required this.proyectoNombre,
    required this.duracionSemanas,
    required this.apoyo,
    required this.estatus,
    required this.createdAt,
    required this.updatedAt,
    this.alumno,
    this.empresa,
    this.carrera,
  });

  factory Estadia.fromJson(Map<String, dynamic> json) {
    return Estadia(
      id: json['id'] ?? 0,
      alumnoId: json['alumno_id'] ?? 0,
      carreraId: json['carrera_id'] ?? 0,
      tutorId: json['tutor_id'] ?? 0,
      empresaId: json['empresa_id'] ?? 0,
      asesorExterno: json['asesor_externo'] ?? '',
      proyectoNombre: json['proyecto_nombre'] ?? '',
      duracionSemanas: json['duracion_semanas'] ?? 0,
      apoyo: json['apoyo'] ?? '',
      estatus: json['estatus'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      alumno: json['alumno'] != null ? User.fromJson(json['alumno']) : null,
      empresa: json['empresa'] != null
          ? Empresa.fromJson(json['empresa'])
          : null,
      carrera: json['carrera'] != null
          ? Carrera.fromJson(json['carrera'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumnoId,
      'carrera_id': carreraId,
      'tutor_id': tutorId,
      'empresa_id': empresaId,
      'asesor_externo': asesorExterno,
      'proyecto_nombre': proyectoNombre,
      'duracion_semanas': duracionSemanas,
      'apoyo': apoyo,
      'estatus': estatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
