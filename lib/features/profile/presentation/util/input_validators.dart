import 'package:flutter/services.dart';

// Formateador personalizado para restringir el formato de hora (máximo 8 caracteres: ej. "04:00 PM")
class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length > 8) {
      return oldValue;
    }
    final regExp = RegExp(r'^[0-9:\sAPMapm]*$');
    if (!regExp.hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

class InputValidators {
  // Solo permite letras y espacios (para Nombre y Apellido)
  static TextInputFormatter get onlyLetters => FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]'),
  );

  // Solo permite números (para Teléfono)
  static TextInputFormatter get onlyNumbers => FilteringTextInputFormatter.digitsOnly;

  // Formato estricto de hora (máximo 8 caracteres y caracteres específicos)
  static TextInputFormatter get timeFormat => _TimeInputFormatter();

  // Solo permite números, puntos y comas (para precio en pesos argentinos)
  static TextInputFormatter get onlyPriceFormat => FilteringTextInputFormatter.allow(
    RegExp(r'[0-9.,]'),
  );

  // Valida si un texto está vacío
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo $fieldName es obligatorio';
    }
    return null;
  }

  // Valida formato de hora
  static String? validateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El horario es obligatorio';
    }
    final timeRegExp = RegExp(r'^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM|am|pm)$');
    if (!timeRegExp.hasMatch(value.trim())) {
      return 'Formato inválido (Ej: 04:00 PM)';
    }
    return null;
  }

  // Valida formato de precio argentino
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El precio es obligatorio';
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'Ingrese un precio válido';
    }
    return null;
  }

  // Valida formato básico de teléfono (Restaurado para que student_modal_form.dart funcione)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (value.length < 8) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }
}