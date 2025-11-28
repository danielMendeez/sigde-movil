String sanitizeInput(String value) {
  // Elimina espacios extremos
  value = value.trim();

  // Bloquea caracteres peligrosos usados en inyección
  final forbidden = RegExp(r"[<>/{}[\];()'$%`]");
  value = value.replaceAll(forbidden, "");

  // Bloquea múltiples espacios
  value = value.replaceAll(RegExp(r"\s{2,}"), " ");

  return value;
}

// text_sanitizer.dart

String sanitizeText(String input) {
  String value = input.trim();

  // Eliminar etiquetas HTML
  value = value.replaceAll(RegExp(r'<[^>]*>', multiLine: true), '');

  // Eliminar posibles intentos de JS o scripts
  value = value.replaceAll(
    RegExp(r'(script|javascript:|onerror|onload)', caseSensitive: false),
    '',
  );

  // Eliminar caracteres peligrosos usados en inyección
  final forbidden = RegExp(r"[<>/{}[\];()'$%`]");
  value = value.replaceAll(forbidden, "");

  // Reemplazar múltiples espacios por uno solo
  value = value.replaceAll(RegExp(r'\s+'), ' ');

  return value;
}

String sanitizeName(String input) {
  String value = input.trim();

  // Solo letras, espacios, acentos básicos y puntos
  value = value.replaceAll(RegExp(r"[^a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s\.\-]"), '');

  value = value.replaceAll(RegExp(r'\s+'), ' ');

  return value;
}

String sanitizeNumber(String input) {
  // Solo números
  return input.replaceAll(RegExp(r'[^0-9]'), '');
}
