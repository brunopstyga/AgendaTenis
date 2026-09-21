import 'package:flutter/material.dart';

class AppTheme {
  // --- PALETA DE COLORES DE TENIS ---
  // El amarillo/verde vibrante característico de las pelotas de tenis
  static const Color tennisYellow = Color(0xFFCCFF00);
  static const Color tennisYellowDark = Color(0xFFA3D900);

  // El blanco clásico de las líneas de la cancha
  static const Color courtWhite = Color(0xFFFFFFFF);

  // Tonos de apoyo para textos, fondos oscuros y contrastes
  static const Color backgroundDark = Color(0xFF121B12); // Verde muy oscuro o casi negro para contraste
  static const Color surfaceLight = Color(0xFFF7F9F4);
  static const Color textPrimary = Color(0xFF1C281C);

  // --- CONFIGURACIÓN DEL TEMA GLOBAL ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: tennisYellow, // <--- Fondo general amarillo pelotita de tenis
      primaryColor: tennisYellowDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tennisYellow,
        primary: tennisYellowDark,
        surface: surfaceLight,
        onSurface: textPrimary,
      ),

      // Estilo global para las AppBar (con detalles blancos inspirados en las líneas)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Estilo global para las Tarjetas (Cards blancas estilo "líneas de cancha")
      cardTheme: CardThemeData(
        color: courtWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white70, width: 1.5),
        ),
      ),

      // Estilo global para los botones principales
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: textPrimary,
          foregroundColor: tennisYellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}