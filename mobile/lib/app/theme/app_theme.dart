import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF102A43),
      onPrimary: Colors.white,
      secondary: Color(0xFFF2994A),
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Color(0xFF102A43),
      background: Color(0xFFFAF0E6),
      onBackground: Color(0xFF102A43),
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      tertiary: Color(0xFFFFA726),
      onTertiary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Color(0xFF102A43),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}