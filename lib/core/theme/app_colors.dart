import 'package:flutter/material.dart';

// Dark theme color palette - Purple themed
class AppColorsDark {
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color primary = Color(0xFF9B59B6); // Purple primary
  static const Color accent = Color(0xFF8E44AD); // Darker purple accent
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color border = Color(0xFF333333);
}

// Light theme color palette - Purple themed
class AppColorsLight {
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color primary = Color(0xFF9B59B6); // Purple primary
  static const Color accent = Color(0xFF8E44AD); // Darker purple accent
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFE0E0E0);
}

// Dynamic color getter based on theme mode
class AppColors {
  static bool isDarkMode = true;

  // Primary colors
  static Color get background =>
      isDarkMode ? AppColorsDark.background : AppColorsLight.background;
  static Color get surface =>
      isDarkMode ? AppColorsDark.surface : AppColorsLight.surface;
  static Color get primary =>
      isDarkMode ? AppColorsDark.primary : AppColorsLight.primary;
  static Color get accent =>
      isDarkMode ? AppColorsDark.accent : AppColorsLight.accent;

  // Text colors
  static Color get textPrimary =>
      isDarkMode ? AppColorsDark.textPrimary : AppColorsLight.textPrimary;
  static Color get textSecondary =>
      isDarkMode ? AppColorsDark.textSecondary : AppColorsLight.textSecondary;

  // UI elements
  static Color get border =>
      isDarkMode ? AppColorsDark.border : AppColorsLight.border;
}
