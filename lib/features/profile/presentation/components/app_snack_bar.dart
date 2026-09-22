import 'package:flutter/material.dart';

class AppSnackBar {
  // SnackBar estándar o de error
  static void show(BuildContext context, String message, {bool isError = false}) {

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: isError ? Colors.red.shade700 : Colors.grey.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}