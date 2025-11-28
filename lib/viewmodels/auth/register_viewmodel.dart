import 'package:flutter/foundation.dart';
import 'package:sigde/models/auth/register_request.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/services/auth/auth_register_service.dart';
import 'package:sigde/services/auth/secure_storage_service.dart';
import 'package:sigde/utils/sanitizer.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRegisterService _authRegisterService = AuthRegisterService();

  bool _isLoading = false;
  String? _errorMessage;

  String? _nombreError;
  String? _apellidoPaternoError;
  String? _apellidoMaternoError;
  String? _curpError;
  String? _numSeguridadSocialError;
  String? _matriculaError;
  String? _correoError;
  String? _telefonoError;
  String? _tipoUsuarioError;
  String? _passwordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get nombreError => _nombreError;
  String? get apellidoPaternoError => _apellidoPaternoError;
  String? get apellidoMaternoError => _apellidoMaternoError;
  String? get curpError => _curpError;
  String? get numSeguridadSocialError => _numSeguridadSocialError;
  String? get matriculaError => _matriculaError;
  String? get correoError => _correoError;
  String? get telefonoError => _telefonoError;
  String? get tipoUsuarioError => _tipoUsuarioError;
  String? get passwordError => _passwordError;

  // Métodos para limpiar errores
  void clearNombreError() {
    _nombreError = null;
    notifyListeners();
  }

  void clearApellidoPaternoError() {
    _apellidoPaternoError = null;
    notifyListeners();
  }

  void clearApellidoMaternoError() {
    _apellidoMaternoError = null;
    notifyListeners();
  }

  void clearCurpError() {
    _curpError = null;
    notifyListeners();
  }

  void clearNumSeguridadSocialError() {
    _numSeguridadSocialError = null;
    notifyListeners();
  }

  void clearMatriculaError() {
    _matriculaError = null;
    notifyListeners();
  }

  void clearCorreoError() {
    _correoError = null;
    notifyListeners();
  }

  void clearTelefonoError() {
    _telefonoError = null;
    notifyListeners();
  }

  void clearTipoUsuarioError() {
    _tipoUsuarioError = null;
    notifyListeners();
  }

  void clearPasswordError() {
    _passwordError = null;
    notifyListeners();
  }

  void clearAllErrors() {
    _errorMessage = null;
    _nombreError = null;
    _apellidoPaternoError = null;
    _apellidoMaternoError = null;
    _curpError = null;
    _numSeguridadSocialError = null;
    _matriculaError = null;
    _correoError = null;
    _telefonoError = null;
    _tipoUsuarioError = null;
    _passwordError = null;
    notifyListeners();
  }

  // ---------------------------
  // VALIDACIÓN + SANITIZACIÓN
  // ---------------------------
  bool validateForm({
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String curp,
    required String numSeguridadSocial,
    required String matricula,
    required String correo,
    required String telefono,
    required String tipoUsuario,
    required String password,
  }) {
    clearAllErrors();

    bool isValid = true;

    // Sanitizar todo
    nombre = sanitizeInput(nombre);
    apellidoPaterno = sanitizeInput(apellidoPaterno);
    apellidoMaterno = sanitizeInput(apellidoMaterno);
    curp = sanitizeInput(curp.toUpperCase());
    numSeguridadSocial = sanitizeInput(numSeguridadSocial);
    matricula = sanitizeInput(matricula);
    correo = sanitizeInput(correo.toLowerCase());
    telefono = sanitizeInput(telefono);
    tipoUsuario = sanitizeInput(tipoUsuario);
    password = sanitizeInput(password);

    // REGEX SEGUROS
    final letters = RegExp(r"^[a-zA-ZÀ-ÿ\s]{2,40}$");
    final curpRegExp = RegExp(r"^[A-Z]{4}\d{6}[HM][A-Z]{5}\d{2}$");
    final nssRegExp = RegExp(r"^\d{11}$");
    final matriculaRegExp = RegExp(r"^[A-Za-z0-9-]{4,20}$");
    final emailRegExp = RegExp(r"^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$");
    final phoneRegExp = RegExp(r"^\d{10}$");
    final passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{12,}$',
    );

    // Validar nombre
    if (!letters.hasMatch(nombre)) {
      _nombreError = "Ingresa un nombre válido";
      isValid = false;
    }

    if (!letters.hasMatch(apellidoPaterno)) {
      _apellidoPaternoError = "Ingresa un apellido paterno válido";
      isValid = false;
    }

    if (!letters.hasMatch(apellidoMaterno)) {
      _apellidoMaternoError = "Ingresa un apellido materno válido";
      isValid = false;
    }

    // CURP
    if (!curpRegExp.hasMatch(curp)) {
      _curpError = "CURP inválida";
      isValid = false;
    }

    // NSS
    if (!nssRegExp.hasMatch(numSeguridadSocial)) {
      _numSeguridadSocialError = "El NSS debe tener 11 números";
      isValid = false;
    }

    // Matrícula
    if (!matriculaRegExp.hasMatch(matricula)) {
      _matriculaError = "Matrícula inválida";
      isValid = false;
    }

    // Email
    if (!emailRegExp.hasMatch(correo)) {
      _correoError = "Correo electrónico inválido";
      isValid = false;
    }

    // Teléfono
    if (!phoneRegExp.hasMatch(telefono)) {
      _telefonoError = "El teléfono debe tener 10 dígitos";
      isValid = false;
    }

    // Tipo usuario
    if (tipoUsuario.isEmpty) {
      _tipoUsuarioError = "Selecciona un tipo de usuario";
      isValid = false;
    }

    // Password
    if (!passwordRegExp.hasMatch(password)) {
      _passwordError =
          "La contraseña debe tener mínimo 12 caracteres, mayúscula, minúscula, número y símbolo";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  // ---------------------------
  // REGISTRO
  // ---------------------------
  Future<User?> register({
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String curp,
    required String numSeguridadSocial,
    required String correo,
    required String matricula,
    required String telefono,
    required String tipoUsuario,
    required String password,
  }) async {
    if (!validateForm(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      curp: curp,
      numSeguridadSocial: numSeguridadSocial,
      correo: correo,
      matricula: matricula,
      telefono: telefono,
      tipoUsuario: tipoUsuario,
      password: password,
    )) {
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final registerRequest = RegisterRequest(
        nombre: sanitizeInput(nombre),
        apellidoPaterno: sanitizeInput(apellidoPaterno),
        apellidoMaterno: sanitizeInput(apellidoMaterno),
        curp: sanitizeInput(curp),
        numSeguridadSocial: sanitizeInput(numSeguridadSocial),
        correo: sanitizeInput(correo),
        matricula: sanitizeInput(matricula),
        telefono: sanitizeInput(telefono),
        tipoUsuario: sanitizeInput(tipoUsuario),
        password: password,
      );

      final user = await _authRegisterService.register(registerRequest);

      if (user != null && user.token.isNotEmpty) {
        await SecureStorageService.saveToken(user.token);
        await SecureStorageService.saveUser(user);
      }

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return null;
    }
  }
}
