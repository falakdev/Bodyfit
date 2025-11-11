import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.background,
      colorScheme: ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.accent,
        surface: AppColorsDark.surface,
        error: const Color(0xFFFF6B6B),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColorsDark.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsDark.primary,
          side: BorderSide(color: AppColorsDark.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsDark.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsDark.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsDark.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsDark.primary, width: 2),
        ),
        labelStyle: TextStyle(color: AppColorsDark.textSecondary),
        hintStyle: TextStyle(color: AppColorsDark.textSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorsDark.surface,
        selectedItemColor: AppColorsDark.primary,
        unselectedItemColor: AppColorsDark.textSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: AppColorsDark.textPrimary),
        displayMedium: TextStyle(color: AppColorsDark.textPrimary),
        displaySmall: TextStyle(color: AppColorsDark.textPrimary),
        headlineMedium: TextStyle(color: AppColorsDark.textPrimary),
        headlineSmall: TextStyle(color: AppColorsDark.textPrimary),
        titleLarge: TextStyle(color: AppColorsDark.textPrimary),
        bodyLarge: TextStyle(color: AppColorsDark.textPrimary),
        bodyMedium: TextStyle(color: AppColorsDark.textPrimary),
        bodySmall: TextStyle(color: AppColorsDark.textSecondary),
        labelLarge: TextStyle(color: AppColorsDark.textPrimary),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.background,
      colorScheme: ColorScheme.light(
        primary: AppColorsLight.primary,
        secondary: AppColorsLight.accent,
        surface: AppColorsLight.surface,
        error: const Color(0xFFFF6B6B),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColorsLight.surface,
        elevation: 1,
        iconTheme: IconThemeData(color: AppColorsLight.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColorsLight.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsLight.primary,
          side: BorderSide(color: AppColorsLight.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsLight.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsLight.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorsLight.primary, width: 2),
        ),
        labelStyle: TextStyle(color: AppColorsLight.textSecondary),
        hintStyle: TextStyle(color: AppColorsLight.textSecondary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorsLight.surface,
        selectedItemColor: AppColorsLight.primary,
        unselectedItemColor: AppColorsLight.textSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: AppColorsLight.textPrimary),
        displayMedium: TextStyle(color: AppColorsLight.textPrimary),
        displaySmall: TextStyle(color: AppColorsLight.textPrimary),
        headlineMedium: TextStyle(color: AppColorsLight.textPrimary),
        headlineSmall: TextStyle(color: AppColorsLight.textPrimary),
        titleLarge: TextStyle(color: AppColorsLight.textPrimary),
        bodyLarge: TextStyle(color: AppColorsLight.textPrimary),
        bodyMedium: TextStyle(color: AppColorsLight.textPrimary),
        bodySmall: TextStyle(color: AppColorsLight.textSecondary),
        labelLarge: TextStyle(color: AppColorsLight.textPrimary),
      ),
    );
  }
}
