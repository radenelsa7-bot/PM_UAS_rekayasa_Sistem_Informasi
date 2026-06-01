import 'package:flutter/material.dart';

class AppTheme {
  // 1. Definisikan variabel warna terlebih dahulu di sini
  static const Color navy = Color(0xFF0A192F);   // Ganti dengan kode Hex navy Anda
  static const Color white = Colors.white;        // Menggunakan warna putih bawaan Flutter
  static const Color orange = Color(0xFFFF6B35); // Ganti dengan kode Hex orange Anda
  static const Color seed = Color(0xFF0A192F);   // Ganti dengan warna utama/seed Anda

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: navy,
      onPrimary: white,
      secondary: orange,
      onSecondary: white,
      surface: white,
      onSurface: navy,
      error: Colors.red,
      onError: white,
      tertiary: orange,
      onTertiary: white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme, 
      appBarTheme: const AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}