import 'package:flutter/foundation.dart';
import 'package:sigde/models/auth/register_request.dart';
import 'package:sigde/models/user/user.dart';
import 'package:sigde/services/auth/auth_register_service.dart';
import 'package:sigde/services/auth/secure_storage_service.dart';

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

  // Métodos para limpiar errores específicos
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

  // Validación del formulario
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

    // Validar nombre
    if (nombre.isEmpty) {
      _nombreError = 'Por favor ingresa tu nombre';
      isValid = false;
    }

    // Validar apellido paterno
    if (apellidoPaterno.isEmpty) {
      _apellidoPaternoError = 'Por favor ingresa tu apellido paterno';
      isValid = false;
    }

    // Validar apellido materno
    if (apellidoMaterno.isEmpty) {
      _apellidoMaternoError = 'Por favor ingresa tu apellido materno';
      isValid = false;
    }

    // Validar CURP
    if (curp.isEmpty) {
      _curpError = 'Por favor ingresa tu CURP';
      isValid = false;
    } else if (curp.length != 18) {
      _curpError = 'La CURP debe tener exactamente 18 caracteres';
      isValid = false;
    }

    // Validar número de seguridad social
    if (numSeguridadSocial.isEmpty) {
      _numSeguridadSocialError =
          'Por favor ingresa tu número de seguridad social';
      isValid = false;
    } else if (numSeguridadSocial.length != 18) {
      _numSeguridadSocialError =
          'El número de seguridad social debe tener exactamente 18 caracteres';
      isValid = false;
    } else {
      final nssRegex = RegExp(r'^[0-9]{18}$');
      if (!nssRegex.hasMatch(numSeguridadSocial)) {
        _numSeguridadSocialError =
            'El número de seguridad social debe contener solo números';
        isValid = false;
      }
    }

    // Validar matrícula
    if (matricula.isEmpty) {
      _matriculaError = 'Por favor ingresa tu matrícula';
      isValid = false;
    } else if (matricula.length != 10) {
      _matriculaError = 'La matrícula debe tener exactamente 10 caracteres';
      isValid = false;
    } else {
      final matriculaRegex = RegExp(r'^[0-9]{10}$');
      if (!matriculaRegex.hasMatch(matricula)) {
        _matriculaError = 'La matrícula debe contener solo números';
        isValid = false;
      }
    }

    // Validar correo
    if (correo.isEmpty) {
      _correoError = 'Por favor ingresa tu correo electrónico';
      isValid = false;
    } else if (!_isValidEmail(correo)) {
      _correoError = 'Por favor ingresa un correo electrónico válido';
      isValid = false;
    }

    // Validar teléfono
    if (telefono.isEmpty || telefono.length != 10) {
      _telefonoError = 'El teléfono debe tener 10 dígitos';
      isValid = false;
    }

    // Validar tipo de usuario
    if (tipoUsuario.isEmpty) {
      _tipoUsuarioError = 'Por favor selecciona tu tipo de usuario';
      isValid = false;
    }

    // Validar contraseña
    if (password.isEmpty) {
      _passwordError = 'Por favor ingresa tu contraseña';
      isValid = false;
    } else if (password.length < 12) {
      _passwordError = 'La contraseña debe tener al menos 12 caracteres';
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

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
    // Primero validar el formulario
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
    _errorMessage = null;
    notifyListeners();

    try {
      final registerRequest = RegisterRequest(
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
      );

      final user = await _authRegisterService.register(registerRequest);

      if (user != null) {
        // Guardar token de sesión sólo si viene en la respuesta
        if (user.token.isNotEmpty) {
          await SecureStorageService.saveToken(user.token);
        }
        await SecureStorageService.saveUser(user);
      }

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }
}
